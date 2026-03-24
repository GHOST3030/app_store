import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/product_query.dart';
import 'product_providers.dart';
import 'product_state.dart';

const _kPageSize = 20;

class ProductNotifier extends AsyncNotifier<ProductState> {
  /// Local mutex — prevents overlapping loadMore() calls.
  bool _loadingMore = false;

  // ─── Build (initial load) ─────────────────────────────────────────────────

  @override
  FutureOr<ProductState> build() => _initialFetch();

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Pull-to-refresh: reloads page 1 + featured products.
  /// FIX 1: reads query BEFORE clobbering state with AsyncLoading.
  Future<void> refresh() async {
    final currentQuery = state.value?.query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _initialFetch(query: currentQuery));
  }

  /// Appends the next page of products.
  /// FIX 3: local mutex instead of state-derived flag.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || _loadingMore || !current.hasMore) return;

    _loadingMore = true;
    state = AsyncData(current.copyWith(isLoadingMore: true, clearFailure: true));

    try {
      final repo = ref.read(productRepositoryProvider);

      // FIX 2: use cursor or offset depending on sort
      final page = await repo.getProducts(
        limit: _kPageSize,
        cursor: current.usesCursorPagination ? current.cursor : null,
        offset: current.usesCursorPagination ? 0 : current.offset,
        query: current.query,
      );

      // De-duplicate by id
      final existingIds = {for (final p in current.products) p.id};
      final unique = page.where((p) => !existingIds.contains(p.id)).toList();

      state = AsyncData(current.copyWith(
        products: [...current.products, ...unique],
        isLoadingMore: false,
        hasMore: page.length >= _kPageSize,
        cursor: (current.usesCursorPagination && unique.isNotEmpty)
            ? unique.last.createdAt.toIso8601String()
            : current.cursor,
        offset: current.offset + page.length,
      ));
    } catch (e, st) {
      log('loadMore failed', error: e, stackTrace: st);
      state = AsyncData(current.copyWith(
        isLoadingMore: false,
        failure: _mapError(e),
      ));
    } finally {
      _loadingMore = false;
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
      offset: products.length,
    );
  }

  Future<void> _reload(ProductQuery query) async {
    _loadingMore = false; // reset mutex on full reload
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _initialFetch(query: query));
  }

  /// FIX 5: proper type-based error mapping — no string matching.
  ProductFailure _mapError(Object error) {
    // Network errors
    if (error is SocketException) return NetworkFailure(error.message);
    if (error is TimeoutException) {
      return NetworkFailure(error.message ?? 'Request timed out');
    }

    // Supabase/PostgREST errors — check HTTP status code
    if (error is PostgrestException) {
      final code = int.tryParse(error.code ?? '');
      if (code != null && code >= 500) {
        return ServerFailure(error.message);
      }
      return UnknownFailure(error.message);
    }

    return UnknownFailure(error.toString());
  }
}
