import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/category/application/category_service.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_event.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required this.categoryService,
  }) : super(const CategoryState()) {
    log('CategoryBloc created', name: 'Bloc');
    on<AddCategoryEvent>(_onAddCategoryEvent);
    on<LoadCategoryEvent>(_onLoadCategoryEvent);
    on<UpdateCategoryEvent>(_onUpdateCategoryEvent);
    add(const LoadCategoryEvent());
  }

  final CategoryService categoryService;

  @override
  Future<void> close() {
    log('CategoryBloc closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _onLoadCategoryEvent(
    LoadCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    String error = '';
    List<Category> categories = [];
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: error,
          categories: categories,
        ),
      );
      final Either<Failure, List<Category>> eitherCategories =
          await categoryService.getAll();
      eitherCategories.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          categories = data;
        },
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error,
            categories: categories,
          ),
        );
      }
    }
  }

  Future<void> _onAddCategoryEvent(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    String error = '';
    final List<Category> categories = [...state.categories];
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: error,
        ),
      );
      final Either<Failure, Category> eitherCategory =
          await categoryService.save(event.category);
      eitherCategory.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          categories.add(data);
        },
      );
      categories.sort((a, b) {
        final int compareType = a.type.id.compareTo(b.type.id);
        if (compareType != 0) return compareType;
        return a.name.compareTo(b.name);
      });
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error,
            categories: categories,
          ),
        );
      }
    }
  }

  Future<void> _onUpdateCategoryEvent(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    String error = '';
    final List<Category> categories = [...state.categories];
    Category category = event.category;
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: error,
        ),
      );
      final Either<Failure, Category> eitherCategory =
          await categoryService.update(event.category);
      eitherCategory.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          category = data;
        },
      );

      final int index = categories.indexWhere(
        (element) => element.code == event.category.code,
      );

      if (index < 0) return;
      categories[index] = category;

      categories.sort((a, b) {
        final int compareType = a.type.id.compareTo(b.type.id);
        if (compareType != 0) return compareType;
        return a.name.compareTo(b.name);
      });
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error,
            categories: categories,
          ),
        );
      }
    }
  }
}
