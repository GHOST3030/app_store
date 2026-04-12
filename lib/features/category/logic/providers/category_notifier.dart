import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/features/category/logic/providers/catgory_provider.dart';

import '../repositories/category_repository.dart';
import '../result/result.dart';
import 'category_state.dart';

class CategoryNotifier extends Notifier<CategoryState> {
  late final CategoryRepository _repository;

  @override
  CategoryState build() {
    _repository = ref.read(categoryRepositoryProvider);
    return CategoryState.initial();
  }

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getCategories();

    switch (result) {
      case Success():
        state = state.copyWith(
          categories: result.data,
          isLoading: false,
          clearError: true,
        );
      case ResultError():
        state = state.copyWith(
          isLoading: false,
          error: result.failure.message,
        );
    }
  }

  Future<void> fetchCategoryById(String id) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSelected: true);

    final result = await _repository.getCategoryById(id);

    switch (result) {
      case Success():
        state = state.copyWith(
          selectedCategory: result.data,
          isLoading: false,
          clearError: true,
        );
      case ResultError():
        state = state.copyWith(
          isLoading: false,
          error: result.failure.message,
        );
    }
  }
}
