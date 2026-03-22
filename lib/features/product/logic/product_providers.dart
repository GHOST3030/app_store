import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';

import '../data/product_repository.dart';
import '../data/supabase_product_repository.dart';
// import '../data/dummyjson_product_repository.dart'; // ← swap here when needed

import 'product_notifier.dart';
import 'product_state.dart';

// ─── Repository provider ──────────────────────────────────────────────────────
//
// To switch data sources, change the implementation returned here.
// Nothing in the logic or UI layers needs to change.

final productRepositoryProvider = Provider<ProductRepository>((ref) {
 
  return SupabaseProductRepository(ref.watch(supabaseClientProvider)); // ← default to Supabase
  // return DummyJsonProductRepository(); // ← uncomment to use DummyJSON
});

// ─── State notifier ───────────────────────────────────────────────────────────

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductNotifier(repository);
});

// ─── Convenience read-only providers ─────────────────────────────────────────

final productListProvider = Provider<List<dynamic>>((ref) {
  return ref.watch(productNotifierProvider).products;
});

final featuredProductsProvider = Provider<List<dynamic>>((ref) {
  return ref.watch(productNotifierProvider).featuredProducts;
});

final productStatusProvider = Provider<ProductStatus>((ref) {
  return ref.watch(productNotifierProvider).status;
});

final productQueryProvider = Provider((ref) {
  return ref.watch(productNotifierProvider).query;
});

final hasMoreProvider = Provider<bool>((ref) {
  return ref.watch(productNotifierProvider).hasMore;
});
