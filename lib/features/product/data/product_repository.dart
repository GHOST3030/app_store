import 'product_model.dart';
import 'product_query.dart';

/// The single contract that the logic and UI layers depend on.
/// Swap implementations (DummyJSON ↔ Supabase) without touching
/// anything outside the data layer.
abstract class ProductRepository {
  /// Fetches a page of products.
  ///
  /// [cursor] — number of already-loaded products (skip offset).
  /// [limit]  — how many products to fetch in this page.
  /// [query]  — optional search / filter / sort options.
  Future<List<ProductModel>> getProducts({
    ProductQuery? query,
    int cursor = 0,
    int limit = 20,
  });
}