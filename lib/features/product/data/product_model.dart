import 'package:flutter/foundation.dart';

/// The single data model for the product feature.
/// Used across all layers — data, logic, and presentation.
@immutable
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String imageUrl;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.createdAt,
  });

  // ─── Serialization ─────────────────────────────────────────────────────────

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrl: json['image_url'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl,
        'created_at': createdAt.toIso8601String(),
      };

  // ─── Utilities ─────────────────────────────────────────────────────────────

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
    DateTime? createdAt,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductModel && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, price: $price, qty: $quantity)';
}
