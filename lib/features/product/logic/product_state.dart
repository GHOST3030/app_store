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

class ProductState {
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final ProductQuery query;
  final bool hasMore;
  final bool isLoadingMore;
  final ProductFailure? failure;

  /// ISO-8601 `createdAt` of the last loaded product — used as cursor.
  final String? cursor;

  const ProductState({
    this.products = const [],
    this.featuredProducts = const [],
    this.query = const ProductQuery(),
    this.hasMore = true,
    this.isLoadingMore = false,
    this.failure,
    this.cursor,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    ProductQuery? query,
    bool? hasMore,
    bool? isLoadingMore,
    ProductFailure? failure,
    String? cursor,
    bool clearFailure = false,
    bool clearCursor = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: clearFailure ? null : failure ?? this.failure,
      cursor: clearCursor ? null : cursor ?? this.cursor,
    );
  }
}
