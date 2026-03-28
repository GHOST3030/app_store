import 'package:new_auth/features/product/data/product_model.dart';

abstract class ProductRepositery {


  Future<List<ProductModel>> getProducts();
  
}