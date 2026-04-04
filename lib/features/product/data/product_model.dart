class ProductModel {
  final String id;
  final String title;
  final String description;
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
  });


<<<<<<< HEAD

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
  // toJson method to convert ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
  
}
=======
  /// Defensive factory — never crashes on malformed JSON.
  ///
  /// Throws [FormatException] only if `id` is missing (the one truly
  /// required field). Everything else falls back to safe defaults.
  factory ProductModel.fromSupabase(Map<String, dynamic> json) {
    final rawId = json['id'];
    if (rawId == null) {
      throw FormatException(
        'ProductModel.fromSupabase: missing required "id" field',
        json,
      );
    }

    return ProductModel(
      id: rawId.toString(),
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      price: _toDouble(json['price']),
      discountPrice:
          json['discount_price'] != null ? _toDouble(json['discount_price']) : null,
      images: _toStringList(json['images']),
      categoryId: (json['category_id'] as String?) ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      rating: _toDouble(json['rating']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  // ─── Private helpers ────────────────────────────────────────────────────────

  static double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0.0;

  static List<String> _toStringList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    return const [];
  }

  @override
  bool operator ==(Object other) => 
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductModel(id: $id, title: $title)';
}
>>>>>>> b9765f071785801d1be213a2cb841965271499ee
