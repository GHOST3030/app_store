import 'dart:developer';

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
    String? cursor, // هذا سيكون الـ ID لآخر عنصر
    ProductQuery? query,
  }) async {
    // 1. تحديد عمود الترتيب
    final sortColumn = _columnFor(query?.sortBy);
    final bool isAscending = query?.sortOrder == SortOrder.asc;

    var builder = _client.from('products').select();

    // 2. تطبيق الفلاتر (نفس منطقك الجميل)
    if (query != null) {
       // ... (كل الـ filters اللي كتبتها ممتازة، اتركها كما هي)
  
   if (query.search != null && query.search!.isNotEmpty) {
        // Escape Postgres wildcards in user input
        final safeSearch = query.search!
            .replaceAll('%', r'\%')
            .replaceAll('_', r'\_');
        builder = builder.ilike('title', '%$safeSearch%');
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

    // 3. احترافية التعامل مع الـ Cursor
    // إذا كنت تستخدم الترتيب التصاعدي، اطلب العناصر التي "أكبر من" المؤشر
    // إذا كنت تستخدم الترتيب التنازلي، اطلب العناصر التي "أصغر من" المؤشر
    if (cursor != null) {
      if (isAscending) {
        builder = builder.gt('id', cursor); // Greater Than للأقدم إلى الأحدث
      } else {
        builder = builder.lt('id', cursor); // Less Than للأحدث إلى الأقدم
      }
    }

    // 4. الترتيب النهائي (Tie-breaker)
    // المحترفون يضعون الـ ID كعامل حسم دائماً لضمان عدم تكرار البيانات
    final response = await builder
        .order(sortColumn, ascending: isAscending)
        .order('id', ascending: isAscending) 
        .limit(limit);

    final res= (response as List)
        .map((row) => ProductModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
     //   log(  ' imges first: ${res.isNotEmpty ? res.first.images.first : 'none'}');
    log('Fetched ${res.length} products with cursor: $cursor,first ID: ${res.isNotEmpty ? res.first.id : 'none'}, last ID: ${res.isNotEmpty ? res.last.id : 'none'}');
  return res;
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _client
        .from('products')
        .select()
        .gte('rating', 4.5)
        .order('created_at', ascending: false)
        .limit(10);
        
  final  res= (response as List)
        .map((row) => ProductModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
      //  log('Fetched ${res.length} featured products last: ${res.isNotEmpty ? res.last.id: 'none'}');

        return res;
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
        return 'id';
    }
  }
}
