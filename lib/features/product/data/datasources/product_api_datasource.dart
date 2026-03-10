import 'dart:convert';

import 'package:http/http.dart' as http;

import '../product_model.dart';
import 'product_remote_datasource.dart';

/// REST API implementation.
/// Replace [_baseUrl] with your actual API base URL.
class ProductApiDataSource implements ProductRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  const ProductApiDataSource({
    required http.Client client,
    String baseUrl = 'https://api.example.com/v1',
  })  : _client = client,
        _baseUrl = baseUrl;

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  void _checkStatus(http.Response res, {List<int> ok = const [200, 201]}) {
    if (!ok.contains(res.statusCode)) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/products'),
      headers: _headers,
    );
    _checkStatus(res);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl/products/$id'),
      headers: _headers,
    );
    _checkStatus(res);
    return ProductModel.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl/products'),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    _checkStatus(res, ok: [200, 201]);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final res = await _client.put(
      Uri.parse('$_baseUrl/products/${product.id}'),
      headers: _headers,
      body: jsonEncode(product.toJson()),
    );
    _checkStatus(res);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final res = await _client.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: _headers,
    );
    _checkStatus(res, ok: [200, 204]);
  }
}
