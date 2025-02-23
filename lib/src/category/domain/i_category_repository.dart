import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/category/domain/category.dart';

abstract class ICategoryRepository {
  const ICategoryRepository();

  Future<Either<Failure, List<Category>>> findByUserCode(
    String userCode, {
    bool? onlyActive,
  });

  Future<Either<Failure, Category>> save(Category category);

  Future<Either<Failure, Category>> update(Category category);
}
