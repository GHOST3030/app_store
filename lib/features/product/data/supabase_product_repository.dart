import 'package:supabase_flutter/supabase_flutter.dart';

import 'product_model.dart';
import 'product_query.dart';
import 'product_repository.dart';

class SupabaseProductRepository implements ProductRepository {
  final SupabaseClient _client;

  const SupabaseProductRepository(this._client);

  // ─── Public API ──────────────────────────────────────────────────────────────

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    String? cursor,
    ProductQuery? query,
  }) async {
    // 1. Start builder
    var builder = _client.from('products').select();

    // 2. Apply filters (does NOT reassign builder — just chains)
    if (query != null) {
      if (query.search != null && query.search!.isNotEmpty) {
        builder = builder.ilike('title', '%${query.search}%');
      }
      if (query.minPrice != null) {
        builder = builder.gte('price', query.minPrice!);
      }
      if (query.maxPrice != null) {
        builder = builder.lte('price', query.maxPrice!);
      }
      if (query.minRating != null) {
        builder = builder.gte('rating', query.minRating!);
      }
      if (query.onlyAvailable == true) {
        builder = builder.gt('stock', 0);
      }
      if (query.categoryId != null && query.categoryId!.isNotEmpty) {
        builder = builder.eq('category_id', query.categoryId!);
      }
      if (query.onlyFeatured == true) {
        builder = builder.gte('rating', 4.5);
      }
    }

    // 3. Apply cursor (true cursor-based pagination via createdAt)
    if (cursor != null) {
      builder = builder.lt('created_at', cursor);
    }

    // 4. Apply sort + limit
    final sortColumn = _columnFor(query?.sortBy);
    final ascending = query?.sortOrder == SortOrder.asc;

    final response = await builder
        .order(sortColumn, ascending: ascending)
        .order('id', ascending: true) // tie-breaker for stable sort
        .limit(limit);

    return (response as List)
        .map((row) => ProductModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _client
        .from('products')
        .select()
        .gte('rating', 4.5)
        .order('created_at', ascending: false)
        .limit(10);

    return (response as List)
        .map((row) => ProductModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  String _columnFor(ProductSortField? field) {
    switch (field) {
      case ProductSortField.price:
        return 'price';
      case ProductSortField.rating:
        return 'rating';
      case ProductSortField.createdAt:
      case null:
        return 'created_at';
    }
  }
}
