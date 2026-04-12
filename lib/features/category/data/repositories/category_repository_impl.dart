import '../../logic/entities/category.dart';
import '../../logic/repositories/category_repository.dart';
import '../../logic/result/result.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _dataSource;

  const CategoryRepositoryImpl({required CategoryRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Result<List<Category>>> getCategories() async {
    final result = await _dataSource.getCategories();

    switch (result) {
      case Success():
        final entities =
            result.data.map((model) => model.toEntity()).toList();
        return Success(data: entities);
      case ResultError():
        return ResultError(failure: result.failure);
    }
  }

  @override
  Future<Result<Category>> getCategoryById(String id) async {
    final result = await _dataSource.getCategoryById(id);

    switch (result) {
      case Success():
        return Success(data: result.data.toEntity());
      case ResultError():
        return ResultError(failure: result.failure);
    }
  }
}
