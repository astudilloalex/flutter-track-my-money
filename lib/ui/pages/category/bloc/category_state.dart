import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/category/domain/category.dart';

final class CategoryState extends Equatable {
  const CategoryState({
    this.categories = const <Category>[],
    this.error = '',
    this.isLoading = false,
  });

  final List<Category> categories;
  final String error;
  final bool isLoading;

  @override
  List<Object?> get props {
    return [
      categories,
      error,
      isLoading,
    ];
  }

  CategoryState copyWith({
    List<Category>? categories,
    String? error,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
