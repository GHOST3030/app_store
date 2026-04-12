import '../entities/category.dart';

class CategoryState {
  final List<Category> categories;
  final Category? selectedCategory;
  final bool isLoading;
  final String? error;

  const CategoryState({
    required this.categories,
    required this.isLoading,
    this.selectedCategory,
    this.error,
  });

  factory CategoryState.initial() {
    return const CategoryState(
      categories: [],
      isLoading: false,
      selectedCategory: null,
      error: null,
    );
  }

  CategoryState copyWith({
    List<Category>? categories,
    Category? selectedCategory,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory:
          clearSelected ? null : selectedCategory ?? this.selectedCategory,
      error: clearError ? null : error ?? this.error,
    );
  }
}
