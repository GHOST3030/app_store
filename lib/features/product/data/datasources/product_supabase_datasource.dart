import 'package:supabase_flutter/supabase_flutter.dart';

import '../product_model.dart';
import 'product_remote_datasource.dart';

/// Supabase implementation.
/// Reads/writes the `products` table.
///
/// Methods may throw [PostgrestException] or other exceptions directly from the
/// Supabase SDK.
class ProductSupabaseDataSource implements ProductRemoteDataSource {
  final SupabaseClient _client;
  static const _table = 'products';

  const ProductSupabaseDataSource({required SupabaseClient client})
      : _client = client;

  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final data = await _client.from(_table).select().eq('id', id).single();
    return ProductModel.fromJson(data);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await _client.from(_table).insert(product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _client.from(_table).update(product.toJson()).eq('id', product.id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
