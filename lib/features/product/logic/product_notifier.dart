
import 'package:flutter_riverpod/legacy.dart';
import '../data/product_query.dart';
import '../data/product_repository.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;

  ProductNotifier(this._repository) : super(const ProductState());

  // ─── Load / Refresh ───────────────────────────────────────────────────────

  /// Loads the first page. Replaces any existing products.
  Future<void> loadProducts({bool refresh = false}) async {
    if (state.isLoading) return;
    if (!refresh && state.isSuccess) return;

    state = state.copyWith(
      status: ProductStatus.loading,
      products: [],
      cursor: 0,
      hasMore: true,
      clearError: true,
    );

    await _fetchPage(cursor: 0, append: false);
    await _loadFeatured();
  }

  /// Refreshes products (e.g. pull-to-refresh).
  Future<void> refresh() => loadProducts(refresh: true);

  // ─── Pagination ───────────────────────────────────────────────────────────

  /// Loads the next page and appends results.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(status: ProductStatus.loadingMore);
    await _fetchPage(cursor: state.cursor, append: true);
  }

  // ─── Search ───────────────────────────────────────────────────────────────

  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    final updated = state.query.copyWith(
      search: trimmed.isEmpty ? null : trimmed,
      clearSearch: trimmed.isEmpty,
    );
    await _applyQuery(updated);
  }

  Future<void> clearSearch() async {
    await _applyQuery(state.query.copyWith(clearSearch: true));
  }

  // ─── Filters ──────────────────────────────────────────────────────────────

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
    final updated = state.query.copyWith(
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
    await _applyQuery(updated);
  }

  Future<void> clearFilters() async {
    await _applyQuery(
      ProductQuery(search: state.query.search),
    );
  }

  // ─── Sort ─────────────────────────────────────────────────────────────────

  Future<void> setSort({
    required ProductSortField sortBy,
    SortOrder order = SortOrder.asc,
  }) async {
    final updated = state.query.copyWith(sortBy: sortBy, sortOrder: order);
    await _applyQuery(updated);
  }

  Future<void> clearSort() async {
    await _applyQuery(state.query.copyWith(clearSortBy: true));
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  /// Applies a new query by resetting pagination and reloading.
  Future<void> _applyQuery(ProductQuery newQuery) async {
    if (newQuery == state.query) return;

    state = state.copyWith(
      status: ProductStatus.loading,
      query: newQuery,
      products: [],
      cursor: 0,
      hasMore: true,
      clearError: true,
    );

    await _fetchPage(cursor: 0, append: false);
  }

  Future<void> _fetchPage({
    required int cursor,
    required bool append,
  }) async {
    try {
      final newProducts = await _repository.getProducts(
        query: state.query,
        cursor: cursor,
        limit: state.limit,
      );

      // De-duplicate by id to prevent ghost entries
      final existingIds = {for (final p in state.products) p.id};
      final unique =
          newProducts.where((p) => !existingIds.contains(p.id)).toList();

      final merged = append ? [...state.products, ...unique] : unique;

      state = state.copyWith(
        status: ProductStatus.success,
        products: merged,
        cursor: cursor + newProducts.length,
        hasMore: newProducts.length >= state.limit,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadFeatured() async {
    try {
      final featured = await _repository.getProducts(
        query: const ProductQuery(onlyFeatured: true),
        cursor: 0,
        limit: 10,
      );
      state = state.copyWith(featuredProducts: featured);
    } catch (_) {
      // Featured section failing silently is acceptable
    }
  }
}
