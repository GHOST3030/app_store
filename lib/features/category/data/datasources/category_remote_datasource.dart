import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/failures/failures.dart';
import '../../logic/result/result.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<CategoryModel>> getCategoryById(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient _client;

  const CategoryRemoteDataSourceImpl({required SupabaseClient client})
      : _client = client;

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _client.from('categories').select();
  // Log length of response if it's a list 
  
      //log length of response if it's a list;

      final models = (response as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(data: models);
    } on SocketException {
      return ResultError(
        failure: const NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    } on PostgrestException catch (e) {
      return ResultError(
        failure: ServerFailure(
          message: e.message.isNotEmpty
              ? e.message              : 'A server error occurred. Please try again.',
        ),
      );
    } catch (e) {
      return ResultError(
        failure: UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<CategoryModel>> getCategoryById(String id) async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('id', id)
          .single();
      final model = CategoryModel.fromJson(response);
      return Success(data: model);
    } on SocketException {
      return ResultError(
        failure: const NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    } on PostgrestException catch (e) {
      return ResultError(
        failure: ServerFailure(
          message: e.message.isNotEmpty
              ? e.message
              : 'A server error occurred. Please try again.',
        ),
      );
    } catch (e) {
      return ResultError(
        failure: UnknownFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }
}
