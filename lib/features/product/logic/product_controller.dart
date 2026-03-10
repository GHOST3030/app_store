import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_model.dart';
import '../data/product_repository.dart';
import 'product_providers.dart';

/// Business-logic controller for the product feature.
///
/// Manages an [AsyncValue<List<ProductModel>>] state.
/// Never imports Supabase, Firebase, or http — only [ProductRepository].
class ProductController extends AsyncNotifier<List<ProductModel>> {
  late ProductRepository _repo;

  @override
  Future<List<ProductModel>> build() async {
    _repo = ref.watch(productRepositoryProvider);
    return _repo.getProducts();
  }

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Reload the full product list from the backend.
  Future<void> loadProducts() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getProducts);
  }

  /// Add a new [product] and refresh the list.
  Future<void> addProduct(ProductModel product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.createProduct(product);
      return _repo.getProducts();
    });
  }

  /// Update an existing [product] and refresh the list.
  Future<void> updateProduct(ProductModel product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.updateProduct(product);
      return _repo.getProducts();
    });
  }

  /// Delete product by [id] and refresh the list.
  Future<void> deleteProduct(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteProduct(id);
      return _repo.getProducts();
    });
  }
}
