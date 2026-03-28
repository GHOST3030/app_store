class ProductModel {
  final String id;
  final String title;
  final String description;
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
  });



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
