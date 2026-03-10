import 'package:new_auth/features/product/data/product_model.dart';

/// Abstract contract all backend implementations must satisfy.
///
/// The repository and everything above it only depends on this interface —
/// never on Supabase, Firebase, or HTTP directly.
abstract interface class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
