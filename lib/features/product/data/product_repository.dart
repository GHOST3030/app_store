import 'datasources/product_remote_datasource.dart';
import 'product_model.dart';

/// The single repository used by the logic layer.
///
/// Depends ONLY on [ProductRemoteDataSource] — never on a concrete backend.
/// Swap the backend by injecting a different datasource via Riverpod.
///
/// Methods may throw exceptions with messages from the backend (e.g. Supabase).
class ProductRepository {
  final ProductRemoteDataSource _dataSource;

  const ProductRepository({required ProductRemoteDataSource dataSource})
      : _dataSource = dataSource;

  /// Returns all products sorted by creation date (newest first).
  Future<List<ProductModel>> getProducts() => _dataSource.getProducts();

  /// Returns a single product by [id].
  Future<ProductModel> getProductById(String id) =>
      _dataSource.getProductById(id);

  /// Creates a new product.
  Future<void> createProduct(ProductModel product) =>
      _dataSource.createProduct(product);

  /// Updates an existing product.
  Future<void> updateProduct(ProductModel product) =>
      _dataSource.updateProduct(product);

  /// Deletes the product with the given [id].
  Future<void> deleteProduct(String id) => _dataSource.deleteProduct(id);
}
