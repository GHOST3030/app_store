// // tool/fetch_products.dart
// // Run with: dart run tool/fetch_products.dart

// import 'package:new_auth/features/category/data/datasources/supabase_category_remote_datasource.dart';
// import 'package:new_auth/features/product/data/supabase_product_repository.dart';
// import 'package:new_auth/mykeysecret/secret.dart';
// import 'package:supabase/supabase.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// Future<String?> fetchProducts(SupabaseProductRepository repo, String? cursor) async {
//   try {
//     final products = await repo.getProducts(cursor: cursor, limit: 20);
//     print('--- Page (cursor=$cursor) → ${products.length} results ---');
//     for (final p in products) {
//       print('  ID: ${p.id} | ${p.title} | createdAt: ${p.createdAt.toIso8601String()}');
//     }
//     return products.isNotEmpty ? products.last.createdAt.toIso8601String() : null;
//   } catch (e) {
//     print('Error: $e');
//     return null;
//   }
// }


