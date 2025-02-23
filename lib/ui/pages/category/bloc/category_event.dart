import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/category/domain/category.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class LoadCategoryEvent extends CategoryEvent {
  const LoadCategoryEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class AddCategoryEvent extends CategoryEvent {
  const AddCategoryEvent({
    required this.category,
  });

  final Category category;

  @override
  List<Object?> get props {
    return [
      category,
    ];
  }
}

final class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent({
    required this.category,
  });

  final Category category;

  @override
  List<Object?> get props {
    return [
      category,
    ];
  }
}
