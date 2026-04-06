import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/product_query.dart';
import 'product_providers.dart';
import 'product_state.dart';

const _kPageSize = 20;

class ProductNotifier extends Notifier<ProductState> {

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  ProductState build() {
    Future.microtask(() => _reload(const ProductQuery()));
    return const ProductState(status: ProductStatus.loading);
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<void> refresh() => _reload(state.query);

  Future<void> loadMore() async {
    final current = state;
    if (current.isLoading || current.isLoadingMore || !current.hasMore) return;

    state = current.copyWith(
      status: ProductStatus.loadingMore,
      clearFailure: true,
    );

    try {
      final page = await ref.read(productRepositoryProvider).getProducts(
            limit: _kPageSize,
            cursor: current.cursor,
            query: current.query,
          );

      final existingIds = {for (final p in current.products) p.id};
      final unique = page.where((p) => !existingIds.contains(p.id)).toList();

      state = current.copyWith(
        status: ProductStatus.success,
        products: [...current.products, ...unique],
        hasMore: page.length >= _kPageSize,
        cursor: page.isNotEmpty ? page.last.id : current.cursor,
      );

      log('loadMore: +${unique.length} | total: ${state.products.length} | hasMore: ${state.hasMore}');
    } catch (e, st) {
      log('loadMore failed', error: e, stackTrace: st);
      // Revert to success — don't wipe the existing list
      state = current.copyWith(
        status: ProductStatus.success,
        failure: _mapError(e),
      );
    }
  }

  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    final q = state.query.copyWith(
      search: trimmed.isEmpty ? null : trimmed,
      clearSearch: trimmed.isEmpty,
    );
    await _reload(q);
  }

  Future<void> setFilter({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyAvailable,
    String? categoryId,
    bool? onlyFeatured,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinRating = false,
    bool clearOnlyAvailable = false,
    bool clearCategoryId = false,
    bool clearOnlyFeatured = false,
  }) async {
    final q = state.query.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      onlyAvailable: onlyAvailable,
      categoryId: categoryId,
      onlyFeatured: onlyFeatured,
      clearMinPrice: clearMinPrice,
      clearMaxPrice: clearMaxPrice,
      clearMinRating: clearMinRating,
      clearOnlyAvailable: clearOnlyAvailable,
      clearCategoryId: clearCategoryId,
      clearOnlyFeatured: clearOnlyFeatured,
    );
    await _reload(q);
  }

  Future<void> setSort({
    required ProductSortField sortBy,
    SortOrder order = SortOrder.desc,
  }) async {
    final q = state.query.copyWith(sortBy: sortBy, sortOrder: order);
    await _reload(q);
  }

  Future<void> clearFilters() async {
    // Preserve only the search term
    await _reload(ProductQuery(search: state.query.search));
  }

  Future<void> clearSort() async {
    final q = state.query.copyWith(clearSortBy: true);
    await _reload(q);
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  Future<void> _reload(ProductQuery query) async {
    state = state.copyWith(
      status: ProductStatus.loading,
      clearFailure: true,
      clearCursor: true,
    );

    try {
      final repo = ref.read(productRepositoryProvider);
      final page = await repo.getProducts(limit: _kPageSize, query: query);

      state = ProductState(
        status: ProductStatus.success,
        products: page,
        query: query,
        hasMore: page.length >= _kPageSize,
        cursor: page.isNotEmpty ? page.last.id : null,
      );

      log('_reload: ${page.length} products | hasMore: ${state.hasMore}');
    } catch (e, st) {
      log('_reload failed', error: e, stackTrace: st);
      state = state.copyWith(
        status: ProductStatus.failure,
        failure: _mapError(e),
      );
    }
  }

  ProductFailure _mapError(Object error) {
    if (error is SocketException) return NetworkFailure(error.message);
    if (error is TimeoutException) {
      return NetworkFailure(error.message ?? 'Request timed out');
    }
    if (error is PostgrestException) {
      final code = int.tryParse(error.code ?? '');
      if (code != null && code >= 500) return ServerFailure(error.message);
      return UnknownFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}