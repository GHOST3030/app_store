import 'product_model.dart';
import 'product_query.dart';

abstract interface class ProductRepository {
  /// Fetches a page of products.
  ///
  /// [cursor] is the ISO-8601 `createdAt` of the last item in the previous
  /// page (true cursor-based pagination). Pass `null` for the first page.
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    ProductQuery? query,
  });

  /// Fetches a fixed list of featured products (rating >= 4.5).
  Future<List<ProductModel>> getFeaturedProducts();
}