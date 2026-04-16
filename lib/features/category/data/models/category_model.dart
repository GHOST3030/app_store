import '../../logic/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['imageurl'] ?? '',
      createdAt: DateTime.parse(json['createdat'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageurl': imageUrl,
      'createdat': createdAt.toIso8601String(),
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }
}
