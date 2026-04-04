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

// ─── Main AsyncNotifier ───────────────────────────────────────────────────────
final productNotifierProvider =
    AsyncNotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);

// ─── Typed convenience selectors ──────────────────────────────────────────────

final productListProvider = Provider<List<ProductModel>>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.products))
      ?? const [];
});

final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.featuredProducts))
      ?? const [];
});

/// FIX: uses .select() for granular rebuilds.
final productIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(productNotifierProvider.select((v) => v.isLoading));
});

final productIsLoadingMoreProvider = Provider<bool>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.isLoadingMore))
      ?? false;
});

final productHasMoreProvider = Provider<bool>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.hasMore))
      ?? false;
});

final productQueryProvider = Provider<ProductQuery>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.query))
      ?? const ProductQuery();
});

final productFailureProvider = Provider<ProductFailure?>((ref) {
  return ref
      .watch(productNotifierProvider.select((v) => v.value?.failure));
});
