import '../entities/category.dart';
import '../result/result.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories();
  Future<Result<Category>> getCategoryById(String id);
}
