// test/features/product/logic/product_notifier_test.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_auth/features/product/data/product_model.dart';
import 'package:new_auth/features/product/data/product_query.dart';
import 'package:new_auth/features/product/data/product_repository.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/product/logic/product_state.dart';

// ─── Mock ─────────────────────────────────────────────────────────────────────

class MockProductRepository implements ProductRepository {
  List<ProductModel> stubbedProducts = [];
  List<ProductModel> stubbedFeatured = [];
  Object? errorToThrow;

  /// Records the arguments of the last `getProducts` call.
  int? lastLimit;
  String? lastCursor;
  int? lastOffset;
  ProductQuery? lastQuery;

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    int offset = 0,
    ProductQuery? query,
  }) async {
    lastLimit = limit;
    lastCursor = cursor;
    lastOffset = offset;
    lastQuery = query;
    await Future<void>.delayed(Duration.zero);
    if (errorToThrow != null) throw errorToThrow!;
    return stubbedProducts;
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future<void>.delayed(Duration.zero);
    if (errorToThrow != null) throw errorToThrow!;
    return stubbedFeatured;
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

ProductModel _product(String id, {DateTime? createdAt, double price = 10}) =>
    ProductModel(
      id: id,
      title: 'Product $id',
      description: 'Desc',
      price: price,
      images: const [],
      categoryId: 'cat',
      stock: 5,
      rating: 4.0,
      createdAt: createdAt ?? DateTime(2024),
    );

ProviderContainer _container(ProductRepository mock) {
  return ProviderContainer(
    overrides: [productRepositoryProvider.overrideWithValue(mock)],
  );
}

/// Waits for the AsyncNotifier to resolve past AsyncLoading.
Future<ProductState> _waitForData(ProviderContainer c) async {
  return await c.read(productNotifierProvider.future);
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ── build / initial load ────────────────────────────────────────────────────

  group('build (initial load)', () {
    test('loads products and featured on first read', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = [_product('1'), _product('2')]
        ..stubbedFeatured = [_product('f1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      final data = await _waitForData(c);

      expect(data.products.length, 2);
      expect(data.featuredProducts.length, 1);
      expect(data.failure, isNull);
      expect(data.cursor, isNotNull); // set from last product
      expect(data.offset, 2);
    });

    test('hasMore = false when < pageSize items returned', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = [_product('1')]; // less than 20

      final c = _container(mock);
      addTearDown(c.dispose);

      final data = await _waitForData(c);
      expect(data.hasMore, isFalse);
    });
  });

  // ── refresh ─────────────────────────────────────────────────────────────────

  group('refresh', () {
    test('preserves the current query on refresh (Fix 1)', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      // Apply a search first
      await c.read(productNotifierProvider.notifier).search('shoes');
      await _waitForData(c);
      expect(mock.lastQuery?.search, 'shoes');

      // Now refresh — the search should survive
      mock.stubbedProducts = [_product('2')];
      await c.read(productNotifierProvider.notifier).refresh();
      final data = await _waitForData(c);

      expect(mock.lastQuery?.search, 'shoes'); // ← FIX 1 verified
      expect(data.products.length, 1);
    });
  });

  // ── loadMore ────────────────────────────────────────────────────────────────

  group('loadMore', () {
    test('appends products and advances cursor/offset', () async {
      // Page 1
      final page1 = List.generate(20, (i) => _product(
        'p$i',
        createdAt: DateTime(2024, 1, 20 - i),
      ));
      final mock = MockProductRepository()..stubbedProducts = page1;

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);
      expect(c.read(productNotifierProvider).requireValue.products.length, 20);

      // Page 2
      final page2 = [_product('x1'), _product('x2')];
      mock.stubbedProducts = page2;

      await c.read(productNotifierProvider.notifier).loadMore();
      final data = c.read(productNotifierProvider).requireValue;

      expect(data.products.length, 22); // 20 + 2
      expect(data.hasMore, isFalse); // page2 < 20
      expect(data.offset, 22);
    });

    test('de-duplicates products by id', () async {
      final page1 = List.generate(20, (i) => _product('p$i'));
      final mock = MockProductRepository()..stubbedProducts = page1;

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      // Page 2 returns some duplicates
      mock.stubbedProducts = [_product('p0'), _product('new1')];
      await c.read(productNotifierProvider.notifier).loadMore();

      final data = c.read(productNotifierProvider).requireValue;
      final ids = data.products.map((p) => p.id).toList();
      expect(ids.where((id) => id == 'p0').length, 1); // no duplicate
      expect(ids.contains('new1'), isTrue);
    });

    test('skips when hasMore is false', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = [_product('1')]; // < 20 → hasMore = false

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);
      expect(c.read(productNotifierProvider).requireValue.hasMore, isFalse);

      mock.stubbedProducts = [_product('should-not-appear')];
      await c.read(productNotifierProvider.notifier).loadMore();

      final data = c.read(productNotifierProvider).requireValue;
      expect(data.products.length, 1); // unchanged
    });

    test('double-call race condition is prevented (Fix 3)', () async {
      // Slow mock — simulates network delay
      final mock = _SlowMockRepository()
        ..stubbedProducts = List.generate(20, (i) => _product('p$i'))
        ..stubbedFeatured = [];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      mock.stubbedProducts = [_product('new1')];
      mock.callCount = 0;

      // Fire two loadMore calls simultaneously
      final f1 = c.read(productNotifierProvider.notifier).loadMore();
      final f2 = c.read(productNotifierProvider.notifier).loadMore();
      await Future.wait([f1, f2]);

      // Only one actual network call should have been made
      expect(mock.callCount, 1);
    });

    test('uses offset pagination when sort != createdAt (Fix 2)', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = List.generate(20, (i) => _product('p$i', price: i * 10));

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      // Change sort to price
      await c.read(productNotifierProvider.notifier).setSort(
            sortBy: ProductSortField.price,
            order: SortOrder.asc,
          );
      await _waitForData(c);

      // Now loadMore — should use offset, not cursor
      mock.stubbedProducts = [_product('new1', price: 999)];
      await c.read(productNotifierProvider.notifier).loadMore();

      expect(mock.lastCursor, isNull); // ← no cursor
      expect(mock.lastOffset, greaterThan(0)); // ← uses offset
    });
  });

  // ── search ──────────────────────────────────────────────────────────────────

  group('search', () {
    test('sets search in query and reloads', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      mock.stubbedProducts = [_product('found')];
      await c.read(productNotifierProvider.notifier).search('boots');
      final data = await _waitForData(c);

      expect(mock.lastQuery?.search, 'boots');
      expect(data.products.first.id, 'found');
    });

    test('empty string clears search', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).search('boots');
      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).search('');
      await _waitForData(c);

      expect(mock.lastQuery?.search, isNull);
    });

    test('trims whitespace', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).search('  boots  ');
      await _waitForData(c);

      expect(mock.lastQuery?.search, 'boots');
    });
  });

  // ── setFilter / clearFilters ────────────────────────────────────────────────

  group('filters', () {
    test('setFilter applies filter params to query', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).setFilter(
            minPrice: 50.0,
            onlyAvailable: true,
          );
      await _waitForData(c);

      expect(mock.lastQuery?.minPrice, 50.0);
      expect(mock.lastQuery?.onlyAvailable, true);
    });

    test('clearFilters preserves search term', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      // Set search + filter
      await c.read(productNotifierProvider.notifier).search('boots');
      await _waitForData(c);
      await c.read(productNotifierProvider.notifier).setFilter(minPrice: 100);
      await _waitForData(c);

      // Clear filters
      await c.read(productNotifierProvider.notifier).clearFilters();
      await _waitForData(c);

      expect(mock.lastQuery?.search, 'boots'); // preserved
      expect(mock.lastQuery?.minPrice, isNull); // cleared
    });
  });

  // ── setSort / clearSort ─────────────────────────────────────────────────────

  group('sort', () {
    test('setSort updates query and reloads', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).setSort(
            sortBy: ProductSortField.price,
            order: SortOrder.asc,
          );
      final data = await _waitForData(c);

      expect(data.query.sortBy, ProductSortField.price);
      expect(data.query.sortOrder, SortOrder.asc);
    });

    test('clearSort nullifies sortBy', () async {
      final mock = MockProductRepository()..stubbedProducts = [_product('1')];

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).setSort(
            sortBy: ProductSortField.price,
          );
      await _waitForData(c);

      await c.read(productNotifierProvider.notifier).clearSort();
      final data = await _waitForData(c);

      expect(data.query.sortBy, isNull);
    });
  });

  // ── error handling ──────────────────────────────────────────────────────────

  group('error handling', () {
    test('network error during build produces AsyncError', () async {
      final mock = MockProductRepository()
        ..errorToThrow = const SocketException('no internet');

      final c = _container(mock);
      addTearDown(c.dispose);

      // Listen to trigger build
      c.listen(productNotifierProvider, (_, __) {});

      // Wait a moment for the build future to fail
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = c.read(productNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<SocketException>());
    });

    test('loadMore error maps SocketException to NetworkFailure (Fix 5)', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = List.generate(20, (i) => _product('p$i'));

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      // Make loadMore throw
      mock.errorToThrow = const SocketException('no internet');
      await c.read(productNotifierProvider.notifier).loadMore();

      final data = c.read(productNotifierProvider).requireValue;
      expect(data.failure, isA<NetworkFailure>());
    });

    test('loadMore error maps TimeoutException to NetworkFailure', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = List.generate(20, (i) => _product('p$i'));

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      mock.errorToThrow = TimeoutException('slow');
      await c.read(productNotifierProvider.notifier).loadMore();

      final data = c.read(productNotifierProvider).requireValue;
      expect(data.failure, isA<NetworkFailure>());
    });

    test('loadMore error maps unknown error to UnknownFailure', () async {
      final mock = MockProductRepository()
        ..stubbedProducts = List.generate(20, (i) => _product('p$i'));

      final c = _container(mock);
      addTearDown(c.dispose);

      await _waitForData(c);

      mock.errorToThrow = Exception('something weird');
      await c.read(productNotifierProvider.notifier).loadMore();

      final data = c.read(productNotifierProvider).requireValue;
      expect(data.failure, isA<UnknownFailure>());
    });
  });

  // ── ProductModel.fromSupabase safety ────────────────────────────────────────

  group('ProductModel.fromSupabase (Fix 8)', () {
    test('throws FormatException when id is missing', () {
      expect(
        () => ProductModel.fromSupabase({'title': 'no id'}),
        throwsFormatException,
      );
    });

    test('handles null/missing fields with defaults', () {
      final model = ProductModel.fromSupabase({
        'id': '123',
        // all other fields missing
      });

      expect(model.id, '123');
      expect(model.title, '');
      expect(model.description, '');
      expect(model.price, 0.0);
      expect(model.discountPrice, isNull);
      expect(model.images, isEmpty);
      expect(model.categoryId, '');
      expect(model.stock, 0);
      expect(model.rating, 0.0);
    });

    test('parses valid data correctly', () {
      final model = ProductModel.fromSupabase({
        'id': 'abc',
        'title': 'Boots',
        'description': 'Nice boots',
        'price': 99.5,
        'discount_price': 79.0,
        'images': ['a.jpg', 'b.jpg'],
        'category_id': 'footwear',
        'stock': 10,
        'rating': 4.8,
        'created_at': '2024-06-15T10:00:00.000Z',
      });

      expect(model.title, 'Boots');
      expect(model.price, 99.5);
      expect(model.discountPrice, 79.0);
      expect(model.images, ['a.jpg', 'b.jpg']);
      expect(model.stock, 10);
      expect(model.createdAt.year, 2024);
    });
  });
}

// ─── Slow mock for race condition test ────────────────────────────────────────

class _SlowMockRepository implements ProductRepository {
  List<ProductModel> stubbedProducts = [];
  List<ProductModel> stubbedFeatured = [];
  int callCount = 0;

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    int offset = 0,
    ProductQuery? query,
  }) async {
    callCount++;
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return stubbedProducts;
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    return stubbedFeatured;
  }
}
