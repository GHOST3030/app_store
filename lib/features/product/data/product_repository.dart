import 'product_model.dart';
import 'product_query.dart';

abstract interface class ProductRepository {
  /// Fetches a page of products.
  ///
  /// Uses cursor-based pagination: pass the ISO-8601 `createdAt` timestamp
  /// of the last item from the previous page as [cursor].
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    ProductQuery? query,
  });

  /// Fetches a fixed list of featured products (rating >= 4.5).
  Future<List<ProductModel>> getFeaturedProducts();
}
