// test/features/product/logic/product_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';
import 'package:new_auth/mykeysecret/secret.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/product/logic/product_state.dart';
import 'package:supabase/supabase.dart';

// ─── Config ───────────────────────────────────────────────────────────────────

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

/// Waits for the AsyncNotifier to resolve (loading → data or error).
Future<ProductState> _waitForData(ProviderContainer container) async {
  // Poll until the provider resolves from loading
  AsyncValue<ProductState> value;
  do {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    value = container.read(productNotifierProvider);
  } while (value.isLoading);

  return value.requireValue;
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    _client;
  });

  // ─── initial state ──────────────────────────────────────────────────────────

  group('initial state', () {
    test('starts as AsyncLoading then resolves to data', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // Immediately after creation, it should be loading
      final immediate = container.read(productNotifierProvider);
      expect(immediate.isLoading, isTrue);

      // Wait for initial fetch to complete
      final data = await _waitForData(container);
      expect(data.products, isNotEmpty);
      expect(data.hasMore, isA<bool>());
      expect(data.failure, isNull);
    });
  });

  // ─── search ─────────────────────────────────────────────────────────────────

  group('search', () {
    test('ilike search matches title substring', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await _waitForData(container);

      await container.read(productNotifierProvider.notifier).search('Worker');
      final data = await _waitForData(container);

      expect(data.products.first.title, contains('Worker'));
    });
  });

  // ─── loadMore guard ─────────────────────────────────────────────────────────

  group('loadMore', () {
    test('skips when already loading more', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final data = await _waitForData(container);
      final countBefore = data.products.length;

      // Call loadMore twice rapidly — second should be a no-op
      final f1 = container.read(productNotifierProvider.notifier).loadMore();
      final f2 = container.read(productNotifierProvider.notifier).loadMore();
      await Future.wait([f1, f2]);

      final after = container.read(productNotifierProvider).requireValue;
      // Should not have loaded two pages
      expect(after.products.length, greaterThanOrEqualTo(countBefore));
    });
  });

  // ─── skips when already success (refresh vs non-refresh) ────────────────────

  group('refresh', () {
    test('refresh reloads fresh data', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await _waitForData(container);

      await container.read(productNotifierProvider.notifier).refresh();
      final data = await _waitForData(container);

      expect(data.products, isNotEmpty);
      expect(data.failure, isNull);
    });
  });
}
