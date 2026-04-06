import '../data/product_model.dart';
import '../data/product_query.dart';

// ─── Sealed failure hierarchy ─────────────────────────────────────────────────

sealed class ProductFailure {
  const ProductFailure([this.message]);
  final String? message;
}

final class NetworkFailure extends ProductFailure {
  const NetworkFailure([super.message]);
}

final class ServerFailure extends ProductFailure {
  const ServerFailure([super.message]);
}

final class UnknownFailure extends ProductFailure {
  const UnknownFailure([super.message]);
}

// ─── State ────────────────────────────────────────────────────────────────────
enum ProductStatus { idle, loading, loadingMore, success, failure }

class ProductState {
  final ProductStatus status;
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final ProductQuery query;
  final bool hasMore;
  final String? cursor;
  final ProductFailure? failure;

  const ProductState({
    this.status = ProductStatus.idle,
    this.products = const [],
    this.query = const ProductQuery(),
    this.hasMore = true,
    this.cursor,
    this.failure, 
     this.featuredProducts=const [],
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    ProductQuery? query,
    bool? hasMore,
    String? cursor,
    ProductFailure? failure,
    bool clearFailure = false,
    bool clearCursor = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      featuredProducts:featuredProducts ?? this.featuredProducts,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      failure: clearFailure ? null : (failure ?? this.failure),
    
    );
  }

  bool get isLoading => status == ProductStatus.loading;
  bool get isLoadingMore => status == ProductStatus.loadingMore;
  bool get isError => status == ProductStatus.failure;
  bool get isSuccess => status == ProductStatus.success;
  bool get isEmpty => products.isEmpty;
}