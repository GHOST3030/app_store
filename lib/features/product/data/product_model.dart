class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String categoryId;
  final int stock;
  final double rating;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price, 
    this.discountPrice,
    required this.images,
    required this.categoryId,
    required this.stock,
    required this.rating,
    required this.createdAt,
  });

  bool get isFeatured => rating >= 4.5;
  bool get isAvailable => stock > 0;
  double get effectivePrice => discountPrice ?? price;

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
      discountPrice: json['discount_price'] != null
          ? _toDouble(json['discount_price'])
          : null,
      images: _toStringList(json['images']),
      categoryId: (json['category_id'] as String?) ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      rating: _toDouble(json['rating']),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
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
