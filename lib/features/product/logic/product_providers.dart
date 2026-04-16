import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';

import '../data/product_model.dart';
import '../data/product_query.dart';
import '../data/product_repository.dart';
import '../data/supabase_product_repository.dart';
import 'product_notifier.dart';
import 'product_state.dart';

// ─── Repository ───────────────────────────────────────────────────────────────
/// Injectable — override in tests with ProviderScope.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return SupabaseProductRepository(ref.watch(supabaseClientProvider));
});

// ─── Main Notifier ───────────────────────────────────────────────────────
final productNotifierProvider =
    NotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);

// ─── Typed convenience selectors ──────────────────────────────────────────────

final productListProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.products)) ??
      const [];
});

final trendingProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.trendingProducts));
});

final dealProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.dealProducts));
});

final specialOffersProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.specialOffers));
});

final newArrivalsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.newArrivals));
});

/// FIX: uses .select() for granular rebuilds.
final productIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.isLoading)) ?? false;
});

final productIsLoadingMoreProvider = Provider<bool>((ref) {
  return ref.watch(
        productNotifierProvider.select((v) => v.isLoadingMore),
      ) ??
      false;
});

final productHasMoreProvider = Provider<bool>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.hasMore)) ??
      false;
});

final productQueryProvider = Provider<ProductQuery>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.query)) ??
      const ProductQuery();
});

final productFailureProvider = Provider<ProductFailure?>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.failure));
});
