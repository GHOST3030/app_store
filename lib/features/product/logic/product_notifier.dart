import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_query.dart';
import 'product_providers.dart';
import 'product_state.dart';

const _kPageSize = 20;

class ProductNotifier extends AsyncNotifier<ProductState> {
  // ─── Build (initial load) ─────────────────────────────────────────────────

  @override
  FutureOr<ProductState> build() => _initialFetch();

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Pull-to-refresh: reloads page 1 + featured products.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _initialFetch(
          query: state.value?.query,
        ));
  }

  /// Appends the next page of products.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true, clearFailure: true));

    try {
      final repo = ref.read(productRepositoryProvider);
      final page = await repo.getProducts(
        limit: _kPageSize,
        cursor: current.cursor,
        query: current.query,
      );

      // De-duplicate by id
      final existingIds = {for (final p in current.products) p.id};
      final unique = page.where((p) => !existingIds.contains(p.id)).toList();

      state = AsyncData(current.copyWith(
        products: [...current.products, ...unique],
        isLoadingMore: false,
        hasMore: page.length >= _kPageSize,
        cursor: unique.isNotEmpty
            ? unique.last.createdAt.toIso8601String()
            : current.cursor,
      ));
    } catch (e, st) {
      log('loadMore failed', error: e, stackTrace: st);
      state = AsyncData(current.copyWith(
        isLoadingMore: false,
        failure: _mapError(e),
      ));
    }
  }

  /// Free-text search.
  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    final q = (state.value?.query ?? const ProductQuery()).copyWith(
      search: trimmed.isEmpty ? null : trimmed,
      clearSearch: trimmed.isEmpty,
    );
    await _reload(q);
  }

  /// Apply filters.
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
    final q = (state.value?.query ?? const ProductQuery()).copyWith(
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

  /// Change sort order.
  Future<void> setSort({
    required ProductSortField sortBy,
    SortOrder order = SortOrder.desc,
  }) async {
    final q = (state.value?.query ?? const ProductQuery()).copyWith(
      sortBy: sortBy,
      sortOrder: order,
    );
    await _reload(q);
  }

  /// Remove all filters (keeps search term).
  Future<void> clearFilters() async {
    final search = state.value?.query.search;
    await _reload(ProductQuery(search: search));
  }

  /// Remove sort (keeps filters intact).
  Future<void> clearSort() async {
    final q = (state.value?.query ?? const ProductQuery()).copyWith(
      clearSortBy: true,
    );
    await _reload(q);
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  Future<ProductState> _initialFetch({ProductQuery? query}) async {
    final repo = ref.read(productRepositoryProvider);
    final q = query ?? const ProductQuery();

    final results = await Future.wait([
      repo.getProducts(limit: _kPageSize, query: q),
      repo.getFeaturedProducts(),
    ]);

    final products = results[0];
    final featured = results[1];

    return ProductState(
      products: products,
      featuredProducts: featured,
      query: q,
      hasMore: products.length >= _kPageSize,
      cursor: products.isNotEmpty
          ? products.last.createdAt.toIso8601String()
          : null,
    );
  }

  Future<void> _reload(ProductQuery query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _initialFetch(query: query));
  }

  ProductFailure _mapError(Object error) {
    if (error is SocketException) {
      return NetworkFailure(error.message);
    }
    final msg = error.toString().toLowerCase();
    if (msg.contains('socket') || msg.contains('timeout')) {
      return NetworkFailure(error.toString());
    }
    if (msg.contains('500') || msg.contains('server')) {
      return ServerFailure(error.toString());
    }
    return UnknownFailure(error.toString());
  }
}
