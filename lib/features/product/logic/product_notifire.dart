import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/features/product/data/product_model.dart';
import 'package:new_auth/features/product/data/product_repositery.dart';

class ProductNotifire extends AsyncNotifier<List<ProductModel>>{
  final ProductRepositery repositery;

  ProductNotifire({required this.repositery});
  @override
  FutureOr<List<ProductModel>> build() {
   
    return repositery.getProducts();
  }g
}