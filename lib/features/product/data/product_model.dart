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

  factory ProductModel.fromSupabase(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      images: List<String>.from(json['images'] as List? ?? []),
      categoryId: (json['category_id'] ?? '').toString(),
      stock: (json['stock'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
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