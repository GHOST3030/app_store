// test/features/product/logic/product_notifier_supabase_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';
import 'package:new_auth/mykeysecret/secret.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/product/logic/product_state.dart';
import 'package:supabase/supabase.dart';

// ─── Config ───────────────────────────────────────────────────────────────────

// ─── Fixed seed IDs ───────────────────────────────────────────────────────────

const _id1 = '00000000-0000-0000-0000-000000000001';
const _id2 = '00000000-0000-0000-0000-000000000002';
const _id3 = '00000000-0000-0000-0000-000000000003';
const _id4 = '00000000-0000-0000-0000-000000000004';
const _id5 = '00000000-0000-0000-0000-000000000005';
const _testIds = [_id1, _id2, _id3, _id4, _id5];

final _seedRows = [
  {
    'id': _id1,
    'title': 'Worker Boots',
    'description': 'Durable boots',
    'price': 80.0,
    'discount_price': null,
    'images': <String>[],
    'category_id': 'footwear',
    'stock': 15,
    'rating': 4.8,
    'created_at': '2024-01-01T00:00:00.000Z',
  },
  {
    'id': _id2,
    'title': 'Running Shoes',
    'description': 'Lightweight runners',
    'price': 120.0,
    'discount_price': 99.0,
    'images': <String>[],
    'category_id': 'footwear',
    'stock': 5,
    'rating': 4.2,
    'created_at': '2024-02-01T00:00:00.000Z',
  },
  {
    'id': _id3,
    'title': 'Leather Wallet',
    'description': 'Slim wallet',
    'price': 35.0,
    'discount_price': null,
    'images': <String>[],
    'category_id': 'accessories',
    'stock': 0,
    'rating': 3.9,
    'created_at': '2024-03-01T00:00:00.000Z',
  },
  {
    'id': _id4,
    'title': 'Canvas Backpack',
    'description': 'Everyday backpack',
    'price': 55.0,
    'discount_price': null,
    'images': <String>[],
    'category_id': 'bags',
    'stock': 30,
    'rating': 4.6,
    'created_at': '2024-04-01T00:00:00.000Z',
  },
  {
    'id': _id5,
    'title': 'Wool Scarf',
    'description': 'Winter scarf',
    'price': 25.0,
    'discount_price': null,
    'images': <String>[],
    'category_id': 'accessories',
    'stock': 8,
    'rating': 3.5,
    'created_at': '2024-05-01T00:00:00.000Z',
  },
];

// ─── Helpers ──────────────────────────────────────────────────────────────────

final _client = SupabaseClient(supabaseUrl, supabaseAnonKey);

Future<void> _seed() async => await _client.from('products').upsert(_seedRows);

Future<void> _clean() async =>
    await _client.from('products').delete().inFilter('id', _testIds);

/// Fresh container wired to the real Supabase client every test.
ProviderContainer _makeContainer() {
  return ProviderContainer(
    overrides: [supabaseClientProvider.overrideWithValue(_client)],
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    _client;
  });

  //setUp(_seed);
  //tearDown(_clean);

  // ─── initial state ──────────────────────────────────────────────────────────

  group('initial state', () {
    test('starts with empty products and initial status', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

       final state = container.read(productNotifierProvider);
      // final prod = state.products;
      // for (var element in prod) {
      //   print(element.id);
      // }
      expect(state.products, isEmpty);
      expect(state.status, ProductStatus.initial);
      expect(state.hasMore, isTrue);
      expect(state.cursor, 0);
      expect(state.errorMessage, isNull);
    });
  });

  // ─── loadProducts ───────────────────────────────────────────────────────────

  group('loadProducts', () {
    test('transitions loading → success and returns seeded products', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final states = <ProductState>[];
      container.listen(
        productNotifierProvider,
        (_, next) => states.add(next),
        fireImmediately: false,
      );

      await container.read(productNotifierProvider.notifier).loadProducts();
      // final prro = states.toList();
      // final mm = prro.first.products;
      // for (var element in mm) {
      //   debugPrint(element.title);
      // }
      expect(states.first.status, ProductStatus.loading);
      expect(states.last.status, ProductStatus.success);
      // expect(states.last.products.map((p) => p.id), containsAll(_testIds));
    });
  });
  test('maps fields correctly from Supabase row', () async {
    final container = _makeContainer();
    addTearDown(container.dispose);

    await container.read(productNotifierProvider.notifier).search('Worker');

    final boots = container.read(productNotifierProvider).products.first;
         // print(boots.title);
    expect(boots.title, contains('Worker'));
    // expect(boots.price, 80.0);
    // expect(boots.rating, 4.8);
    // expect(boots.stock, 15);
    // expect(boots.categoryId, 'footwear');
    // expect(boots.discountPrice, isNull);
  });

      // test('maps discount_price when present', () async {
      //   final container = _makeContainer();
      //   addTearDown(container.dispose);

      //   await container.read(productNotifierProvider.notifier).loadProducts();

      //   final shoes = container
      //       .read(productNotifierProvider)
      //       .products
      //       .firstWhere((p) => p.id == _id2);

      //   expect(shoes.discountPrice, 99.0);
      // });

      test('skips when already loading', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        // Force loading state
        container.read(productNotifierProvider.notifier).state = container
            .read(productNotifierProvider)
            .copyWith(status: ProductStatus.loading);

        await container.read(productNotifierProvider.notifier).loadProducts();

        // State must stay loading — no success transition happened
        expect(container.read(productNotifierProvider).status, ProductStatus.loading);
      });

      test('skips when already success and refresh=false', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(productNotifierProvider.notifier).loadProducts();

        // Mutate DB — delete a row
        await _client.from('products').delete().eq('title', 'Worker 6');

        // Without refresh, notifier should NOT re-fetch
        await container.read(productNotifierProvider.notifier).loadProducts();

        // _id1 still present because no re-fetch happened
        final ids = container.read(productNotifierProvider).products.map((p) => p.title);
        expect(ids, contains('Worker'));
      });

  //     test('refresh=true re-fetches and reflects DB changes', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).loadProducts();

  //       // Delete a row from DB
  //       await _client.from('products').delete().eq('id', _id1);

  //       // With refresh, notifier should re-fetch
  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       final ids = container.read(productNotifierProvider).products.map((p) => p.id);
  //       expect(ids, isNot(contains(_id1)));
  //     });

  //     test('sets hasMore = false when items returned < limit', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       // Force limit bigger than seed count so all 5 come back at once
  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 100);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       expect(container.read(productNotifierProvider).hasMore, isFalse);
  //     });

  //     test('sets hasMore = true when items returned == limit', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       // Set limit to 2 — we have 5 seed rows so 2 will come back
  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 2);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       expect(container.read(productNotifierProvider).hasMore, isTrue);
  //     });

  //     test('cursor equals number of items returned', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 3);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       expect(container.read(productNotifierProvider).cursor, 3);
  //     });

  //     test('also loads featured products (rating >= 4.5)', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).loadProducts();

  //       final featuredIds = container
  //           .read(productNotifierProvider)
  //           .featuredProducts
  //           .map((p) => p.id)
  //           .toList();

  //       // Boots (4.8) and Backpack (4.6) qualify
  //       expect(featuredIds, containsAll([_id1, _id4]));
  //       // Scarf (3.5) does not
  //       expect(featuredIds, isNot(contains(_id5)));
  //     });
  //   });

  //   // ─── loadMore ───────────────────────────────────────────────────────────────

  //   group('loadMore', () {
  //     test('appends next page and advances cursor', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       // limit=3 → page 1 gets 3 items
  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 3);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       final afterPage1 = container.read(productNotifierProvider).products.length;
  //       expect(afterPage1, 3);

  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       final afterPage2 = container.read(productNotifierProvider).products.length;
  //       expect(afterPage2, greaterThan(afterPage1));
  //       expect(container.read(productNotifierProvider).cursor, afterPage2);
  //     });

  //     test('pages do not overlap', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 3);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       final page1Ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toSet();

  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       final allIds = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       final page2Ids = allIds.skip(3).toSet();

  //       // No product appears in both pages
  //       expect(page1Ids.intersection(page2Ids), isEmpty);
  //     });

  //     test('all pages combined cover all seed rows', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 3);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);
  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       final allIds = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(allIds, containsAll(_testIds));
  //     });

  //     test('skips when hasMore is false', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       // limit=100 → all 5 rows return → hasMore false
  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 100);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);

  //       final countBefore =
  //           container.read(productNotifierProvider).products.length;

  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       expect(
  //           container.read(productNotifierProvider).products.length, countBefore);
  //     });

  //     test('skips when already loadingMore', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(status: ProductStatus.loadingMore);

  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       // State must remain loadingMore — no transition happened
  //       expect(container.read(productNotifierProvider).status,
  //           ProductStatus.loadingMore);
  //     });
  //   });

  //   // ─── search ─────────────────────────────────────────────────────────────────

  //   group('search', () {
  //     test('ilike search matches title substring', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Worker');

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, [_id1]);
  //     });

  //     test('search is case-insensitive', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('worker');

  //       expect(container.read(productNotifierProvider).products.length, 1);
  //       expect(
  //           container.read(productNotifierProvider).products.first.id, _id1);
  //     });

  //     test('partial match works', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Scarf');

  //       expect(container.read(productNotifierProvider).products.any((p) => p.id == _id5), isTrue);
  //     });

  //     test('no match returns empty products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .search('xyznotexist');

  //       expect(container.read(productNotifierProvider).products, isEmpty);
  //     });

  //     test('trims whitespace from keyword', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .search('  Worker  ');

  //       expect(container.read(productNotifierProvider).query.search, 'Worker');
  //       expect(container.read(productNotifierProvider).products.first.id, _id1);
  //     });

  //     test('empty string clears search and reloads all', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Worker');
  //       await container.read(productNotifierProvider.notifier).search('');

  //       expect(container.read(productNotifierProvider).query.search, isNull);
  //       expect(container.read(productNotifierProvider).products.map((p) => p.id),
  //           containsAll(_testIds));
  //     });

  //     test('resets cursor to 0 on new search', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       container.read(productNotifierProvider.notifier).state = container
  //           .read(productNotifierProvider)
  //           .copyWith(limit: 3);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .loadProducts(refresh: true);
  //       await container.read(productNotifierProvider.notifier).loadMore();

  //       // cursor is now > 3
  //       await container.read(productNotifierProvider.notifier).search('Boots');

  //       expect(container.read(productNotifierProvider).cursor,
  //           container.read(productNotifierProvider).products.length);
  //     });
  //   });

  //   // ─── clearSearch ────────────────────────────────────────────────────────────

  //   group('clearSearch', () {
  //     test('nullifies search and reloads all products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Worker');
  //       await container.read(productNotifierProvider.notifier).clearSearch();

  //       expect(container.read(productNotifierProvider).query.search, isNull);
  //       expect(container.read(productNotifierProvider).products.map((p) => p.id),
  //           containsAll(_testIds));
  //     });
  //   });

  //   // ─── setFilter ──────────────────────────────────────────────────────────────

  //   group('setFilter', () {
  //     test('minPrice filters out cheaper products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(minPrice: 70.0);

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id1, _id2]));
  //       expect(ids, isNot(contains(_id3)));
  //       expect(ids, isNot(contains(_id5)));
  //     });

  //     test('maxPrice filters out expensive products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(maxPrice: 40.0);

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id3, _id5]));
  //       expect(ids, isNot(contains(_id2)));
  //     });

  //     test('minPrice + maxPrice form a price range', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setFilter(
  //             minPrice: 30.0,
  //             maxPrice: 60.0,
  //           );

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id3, _id4]));
  //       expect(ids, isNot(contains(_id1)));
  //       expect(ids, isNot(contains(_id2)));
  //     });

  //     test('minRating filters out low-rated products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(minRating: 4.5);

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id1, _id4]));
  //       expect(ids, isNot(contains(_id5)));
  //       expect(ids, isNot(contains(_id3)));
  //     });

  //     test('onlyAvailable excludes out-of-stock products', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(onlyAvailable: true);

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, isNot(contains(_id3))); // stock = 0
  //       expect(ids, containsAll([_id1, _id2, _id4, _id5]));
  //     });

  //     test('categoryId returns only matching category', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(categoryId: 'accessories');

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id3, _id5]));
  //       expect(ids, isNot(contains(_id1)));
  //       expect(ids, isNot(contains(_id4)));
  //     });

  //     test('onlyFeatured returns products with rating >= 4.5', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(onlyFeatured: true);

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       expect(ids, containsAll([_id1, _id4]));
  //       expect(ids, isNot(contains(_id5)));
  //     });

  //     test('clearMinPrice flag nullifies minPrice and reloads', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(minPrice: 70.0);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(clearMinPrice: true);

  //       expect(container.read(productNotifierProvider).query.minPrice, isNull);
  //       expect(container.read(productNotifierProvider).products.map((p) => p.id),
  //           containsAll(_testIds));
  //     });

  //     test('replaces products on filter change', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).loadProducts();
  //       final countBefore =
  //           container.read(productNotifierProvider).products.length;

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(minPrice: 100.0);

  //       final countAfter =
  //           container.read(productNotifierProvider).products.length;

  //       expect(countAfter, lessThan(countBefore));
  //     });
  //   });

  //   // ─── clearFilters ───────────────────────────────────────────────────────────

  //   group('clearFilters', () {
  //     test('wipes all filters but preserves search', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Boots');
  //       await container.read(productNotifierProvider.notifier).setFilter(
  //             minPrice: 10.0,
  //             maxPrice: 200.0,
  //             minRating: 4.0,
  //           );

  //       await container.read(productNotifierProvider.notifier).clearFilters();

  //       final q = container.read(productNotifierProvider).query;
  //       expect(q.search, 'Boots');
  //       expect(q.minPrice, isNull);
  //       expect(q.maxPrice, isNull);
  //       expect(q.minRating, isNull);
  //       expect(q.categoryId, isNull);
  //       expect(q.onlyAvailable, isNull);
  //       expect(q.onlyFeatured, isNull);
  //     });

  //     test('after clearFilters all seed products are visible again', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(minPrice: 500.0);

  //       expect(container.read(productNotifierProvider).products, isEmpty);

  //       await container.read(productNotifierProvider.notifier).clearFilters();

  //       expect(
  //           container.read(productNotifierProvider).products.map((p) => p.id),
  //           containsAll(_testIds));
  //     });
  //   });

  //   // ─── setSort ────────────────────────────────────────────────────────────────

  //   group('setSort', () {
  //     test('price ascending returns products sorted by price low→high', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setSort(
  //             sortBy: ProductSortField.price,
  //             order: SortOrder.asc,
  //           );

  //       final prices = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.price)
  //           .toList();

  //       expect(prices, orderedEquals(prices.toList()..sort()));
  //     });

  //     test('price descending returns products sorted by price high→low', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setSort(
  //             sortBy: ProductSortField.price,
  //             order: SortOrder.desc,
  //           );

  //       final prices = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.price)
  //           .toList();

  //       expect(prices,
  //           orderedEquals(prices.toList()..sort((a, b) => b.compareTo(a))));
  //     });

  //     test('rating ascending returns products sorted by rating low→high',
  //         () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setSort(
  //             sortBy: ProductSortField.rating,
  //             order: SortOrder.asc,
  //           );

  //       final ratings = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.rating)
  //           .toList();

  //       expect(ratings, orderedEquals(ratings.toList()..sort()));
  //     });

  //     test('newest sort returns products ordered by createdAt descending',
  //         () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setSort(
  //             sortBy: ProductSortField.newest,
  //           );

  //       final dates = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.createdAt)
  //           .toList();

  //       expect(
  //           dates,
  //           orderedEquals(
  //               dates.toList()..sort((a, b) => b.compareTo(a))));
  //     });

  //     test('default (no sort) orders by createdAt descending', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).loadProducts();

  //       final dates = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.createdAt)
  //           .toList();

  //       expect(
  //           dates,
  //           orderedEquals(
  //               dates.toList()..sort((a, b) => b.compareTo(a))));
  //     });
  //   });

  //   // ─── clearSort ──────────────────────────────────────────────────────────────

  //   group('clearSort', () {
  //     test('nullifies sortBy and falls back to default order', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setSort(
  //             sortBy: ProductSortField.price,
  //             order: SortOrder.asc,
  //           );

  //       await container.read(productNotifierProvider.notifier).clearSort();

  //       expect(container.read(productNotifierProvider).query.sortBy, isNull);

  //       // Back to default created_at desc
  //       final dates = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.createdAt)
  //           .toList();

  //       expect(
  //           dates,
  //           orderedEquals(
  //               dates.toList()..sort((a, b) => b.compareTo(a))));
  //     });
  //   });

  //   // ─── combined filters ───────────────────────────────────────────────────────

  //   group('combined filters', () {
  //     test('search + category narrows results correctly', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).search('Boots');
  //       await container
  //           .read(productNotifierProvider.notifier)
  //           .setFilter(categoryId: 'footwear');

  //       expect(container.read(productNotifierProvider).products.length, 1);
  //       expect(
  //           container.read(productNotifierProvider).products.first.id, _id1);
  //     });

  //     test('minPrice + onlyAvailable excludes out-of-stock cheap items',
  //         () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setFilter(
  //             minPrice: 30.0,
  //             onlyAvailable: true,
  //           );

  //       final ids = container
  //           .read(productNotifierProvider)
  //           .products
  //           .map((p) => p.id)
  //           .toList();

  //       // Wallet (35, stock=0) excluded
  //       expect(ids, isNot(contains(_id3)));
  //       expect(ids, containsAll([_id1, _id2]));
  //     });

  //     test('minRating + category returns correct subset', () async {
  //       final container = _makeContainer();
  //       addTearDown(container.dispose);

  //       await container.read(productNotifierProvider.notifier).setFilter(
  //             categoryId: 'footwear',
  //             minRating: 4.5,
  //           );

  //       // Boots (4.8) passes; Shoes (4.2) does not
  //       expect(container.read(productNotifierProvider).products.length, 1);
  //       expect(
  //           container.read(productNotifierProvider).products.first.id, _id1);
  //     });
  //   });
  // }
}
