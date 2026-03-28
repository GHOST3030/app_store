import 'product_model.dart';
import 'product_query.dart';

abstract interface class ProductRepository {
  /// Fetches a page of products.
  ///
  /// Pagination strategy depends on the sort:
  /// - **createdAt DESC** (default): uses [cursor] — the ISO-8601 `createdAt`
  ///   of the last item in the previous page.
  /// - **Any other sort**: uses [offset] — the number of items already loaded.
  ///
  /// Only one of [cursor] / [offset] should be non-null per call.
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    int offset = 0,
    ProductQuery? query,
  });

  /// Fetches a fixed list of featured products (rating >= 4.5).
  Future<List<ProductModel>> getFeaturedProducts();
}