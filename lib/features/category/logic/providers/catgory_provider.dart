import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';
import 'package:new_auth/features/category/data/datasources/category_remote_datasource.dart';
import 'package:new_auth/features/category/data/repositories/category_repository_impl.dart';
import 'package:new_auth/features/category/logic/providers/category_notifier.dart';
import 'package:new_auth/features/category/logic/providers/category_state.dart';
import 'package:new_auth/features/category/logic/repositories/category_repository.dart';

final categorydatasourceprovider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl(
    client: ref.watch(supabaseClientProvider),
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dataSource = ref.watch(categorydatasourceprovider);
  return CategoryRepositoryImpl(dataSource: dataSource);
});

final categoryNotifierProvider =
    NotifierProvider<CategoryNotifier, CategoryState>(CategoryNotifier.new);