// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import 'product_model.dart';
// import 'product_query.dart';
// import 'product_repository.dart';

// /// DummyJSON implementation of [ProductRepository].
// ///
// /// Uses cursor-based pagination by mapping cursor → skip parameter.
// /// Filtering and sorting are handled server-side where the API supports
// /// it, and client-side for the rest.
// ///
// /// To activate: change the provider in product_providers.dart to
// /// return DummyJsonProductRepository(). Nothing else changes.
// class DummyJsonProductRepository implements ProductRepository {
//   static const String _baseUrl = 'https://dummyjson.com';

//   final http.Client _http;

//   DummyJsonProductRepository({http.Client? client})
//       : _http = client ?? http.Client();

//   @override
//   Future<List<ProductModel>> getProducts({
//     ProductQuery? query,
//     int cursor = 0,
//     int limit = 20,
//   }) async {
//     final uri = _buildUri(query: query, skip: cursor, limit: limit);
//     final response = await _http.get(uri);

//     if (response.statusCode != 200) {
//       throw Exception(
//         'DummyJSON error ${response.statusCode}: ${response.body}',
//       );
//     }

//     final body = json.decode(response.body) as Map<String, dynamic>;
//     final products = (body['products'] as List)
//         .map((e) => ProductModel.fromDummyJson(e as Map<String, dynamic>))
//         .toList();

//     return _applyClientSideFilters(products, query);
//   }

//   // ─── URI builder ──────────────────────────────────────────────────────────

//   Uri _buildUri({
//     required ProductQuery? query,
//     required int skip,
//     required int limit,
//   }) {
//     // DummyJSON supports: /products, /products/search?q=, /products/category/:id
//     if (query?.search != null && query!.search!.isNotEmpty) {
//       return Uri.parse('$_baseUrl/products/search').replace(
//         queryParameters: {
//           'q': query.search!,
//           'skip': skip.toString(),
//           'limit': limit.toString(),
//           ..._sortParams(query),
//         },
//       );
//     }

//     if (query?.categoryId != null && query!.categoryId!.isNotEmpty) {
//       return Uri.parse(
//         '$_baseUrl/products/category/${Uri.encodeComponent(query.categoryId!)}',
//       ).replace(
//         queryParameters: {
//           'skip': skip.toString(),
//           'limit': limit.toString(),
//           ..._sortParams(query),
//         },
//       );
//     }

//     return Uri.parse('$_baseUrl/products').replace(
//       queryParameters: {
//         'skip': skip.toString(),
//         'limit': limit.toString(),
//         ..._sortParams(query),
//       },
//     );
//   }

//   Map<String, String> _sortParams(ProductQuery? query) {
//     if (query?.sortBy == null) return {};

//     String sortByParam;
//     switch (query!.sortBy!) {
//       case ProductSortField.price:
//         sortByParam = 'price';
//         break;
//       case ProductSortField.rating:
//         sortByParam = 'rating';
//         break;
//       case ProductSortField.newest:
//         // DummyJSON doesn't have createdAt — fallback to id desc
//         return {'sortBy': 'id', 'order': 'desc'};
//     }

//     return {
//       'sortBy': sortByParam,
//       'order': query.sortOrder == SortOrder.asc ? 'asc' : 'desc',
//     };
//   }

//   // ─── Client-side filtering (for fields DummyJSON doesn't support) ─────────

//   List<ProductModel> _applyClientSideFilters(
//     List<ProductModel> products,
//     ProductQuery? query,
//   ) {
//     if (query == null) return products;

//     return products.where((p) {
//       if (query.minPrice != null && p.price < query.minPrice!) return false;
//       if (query.maxPrice != null && p.price > query.maxPrice!) return false;
//       if (query.minRating != null && p.rating < query.minRating!) return false;
//       if (query.onlyAvailable == true && !p.isAvailable) return false;
//       if (query.onlyFeatured == true && !p.isFeatured) return false;
//       return true;
//     }).toList();
//   }
// }
