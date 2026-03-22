import 'package:supabase_flutter/supabase_flutter.dart';

import 'product_model.dart';
import 'product_query.dart';
import 'product_repository.dart';

/// Supabase implementation of [ProductRepository].
///
/// Assumes a `products` table with the following columns:
///   id, title, description, price, discount_price,
///   images (text[]), category_id, stock, rating, created_at
///
/// To switch from DummyJSON to Supabase, change the provider in
/// product_providers.dart to return SupabaseProductRepository().
/// Nothing else changes.
class SupabaseProductRepository implements ProductRepository {
  final SupabaseClient _client;

  SupabaseProductRepository(this._client);

  @override
  Future<List<ProductModel>> getProducts({
    ProductQuery? query,
    int cursor = 0,
    int limit = 20,
  }) async {
    var builder = _client
        .from('products')
        .select()
        .range(cursor, cursor + limit - 1);

    builder = _applyFilters(builder, query);
    builder = _applySort(builder, query);

    final response = await builder;

    return (response as List)
        .map((row) => ProductModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  dynamic _applyFilters(dynamic builder, ProductQuery? query) {
    if (query == null) return builder;

    if (query.search != null && query.search!.isNotEmpty) {
      // Full-text search on title and description
     builder= _client
      .from('products')
      .select('*');
      builder = builder.ilike('title', '%${query.search}%');
    }

    if (query.minPrice != null) {
      builder = builder.gte('price', query.minPrice);
    }

    if (query.maxPrice != null) {
      builder = builder.lte('price', query.maxPrice);
    }

    if (query.minRating != null) {
      builder = builder.gte('rating', query.minRating);
    }

    if (query.onlyAvailable == true) {
      builder = builder.gt('stock', 0);
    }

    if (query.categoryId != null && query.categoryId!.isNotEmpty) {
      builder = builder.eq('category_id', query.categoryId!);
    }

    if (query.onlyFeatured == true) {
      // Featured = rating >= 4.5 (matches ProductModel.isFeatured)
      builder = builder.gte('rating', 4.5);
    }

    return builder;
  }

  dynamic _applySort(dynamic builder, ProductQuery? query) {
    if (query?.sortBy == null) {
      return builder.order('created_at', ascending: false);
    }

    final ascending = query!.sortOrder == SortOrder.asc;

    switch (query.sortBy!) {
      case ProductSortField.price:
        return builder.order('price', ascending: ascending);
      case ProductSortField.rating:
        return builder.order('rating', ascending: ascending);
      case ProductSortField.newest:
        return builder.order('created_at', ascending: false);
    }
  }
}
