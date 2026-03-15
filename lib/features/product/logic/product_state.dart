import '../data/product_model.dart';
import '../data/product_query.dart';

enum ProductStatus { initial, loading, loadingMore, success, failure }

class ProductState {
  final ProductStatus status;
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final ProductQuery query;

  // Pagination
  final int cursor;
  final int limit;
  final bool hasMore;

  // Error
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.featuredProducts = const [],
    this.query = const ProductQuery.empty(),
    this.cursor = 0,
    this.limit = 20,
    this.hasMore = true,
    this.errorMessage,
  });

  bool get isInitial => status == ProductStatus.initial;
  bool get isLoading => status == ProductStatus.loading;
  bool get isLoadingMore => status == ProductStatus.loadingMore;
  bool get isSuccess => status == ProductStatus.success;
  bool get isFailure => status == ProductStatus.failure;
  bool get isEmpty => isSuccess && products.isEmpty;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    ProductQuery? query,
    int? cursor,
    int? limit,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      query: query ?? this.query,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
