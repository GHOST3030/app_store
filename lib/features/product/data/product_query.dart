enum ProductSortField { price, rating, createdAt }

enum SortOrder { asc, desc }

class ProductQuery {
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? onlyAvailable;
  final String? categoryId;
  final bool? onlyFeatured;
  final ProductSortField? sortBy;
  final SortOrder sortOrder;

  const ProductQuery({
    this.search,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.onlyAvailable,
    this.categoryId,
    this.onlyFeatured,
    this.sortBy,
    this.sortOrder = SortOrder.desc,
  });

  bool get hasActiveFilters =>
      search != null ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      onlyAvailable == true ||
      categoryId != null ||
      onlyFeatured == true ||
      sortBy != null;

  ProductQuery copyWith({
    String? search,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyAvailable,
    String? categoryId,
    bool? onlyFeatured,
    ProductSortField? sortBy,
    SortOrder? sortOrder,
    bool clearSearch = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinRating = false,
    bool clearOnlyAvailable = false,
    bool clearCategoryId = false,
    bool clearOnlyFeatured = false,
    bool clearSortBy = false,
  }) {
    return ProductQuery(
      search: clearSearch ? null : search ?? this.search,
      minPrice: clearMinPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearMaxPrice ? null : maxPrice ?? this.maxPrice,
      minRating: clearMinRating ? null : minRating ?? this.minRating,
      onlyAvailable:
          clearOnlyAvailable ? null : onlyAvailable ?? this.onlyAvailable,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      onlyFeatured:
          clearOnlyFeatured ? null : onlyFeatured ?? this.onlyFeatured,
      sortBy: clearSortBy ? null : sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductQuery &&
          other.search == search &&
          other.minPrice == minPrice &&
          other.maxPrice == maxPrice &&
          other.minRating == minRating &&
          other.onlyAvailable == onlyAvailable &&
          other.categoryId == categoryId &&
          other.onlyFeatured == onlyFeatured &&
          other.sortBy == sortBy &&
          other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(search, minPrice, maxPrice, minRating,
      onlyAvailable, categoryId, onlyFeatured, sortBy, sortOrder);
}