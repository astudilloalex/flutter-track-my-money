import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/app/util/string_util.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/category/domain/i_category_repository.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class CategoryService {
  const CategoryService(
    this._repository, {
    required this.authRepository,
  });

  final ICategoryRepository _repository;
  final IAuthRepository authRepository;

  Future<Either<Failure, List<Category>>> getAll({
    bool? onlyActive,
  }) async {
    try {
      final Either<Failure, User> eitherUser = await authRepository.currentUser;
      if (eitherUser.isLeft()) {
        final Failure? failure = eitherUser.fold(
          (fail) => fail,
          (_) => null,
        );
        return Left(failure!);
      }

      final User? user = eitherUser.fold(
        (_) => null,
        (data) => data,
      );

      return await _repository.findByUserCode(
        user!.code,
        onlyActive: onlyActive,
      );
    } catch (e) {
      return Left(
        ServiceFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, Category>> save(Category category) async {
    try {
      final Either<Failure, User> eitherUser = await authRepository.currentUser;
      if (eitherUser.isLeft()) {
        final Failure? failure = eitherUser.fold(
          (fail) => fail,
          (_) => null,
        );
        return Left(failure!);
      }

      final User? user = eitherUser.fold(
        (_) => null,
        (data) => data,
      );

      return await _repository.save(
        category.copyWith(
          active: true,
          code: StringUtil.generateRandomCode(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userCode: user!.code,
        ),
      );
    } catch (e) {
      return Left(
        ServiceFailure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, Category>> update(Category category) async {
    try {
      return await _repository.update(
        category.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(
        ServiceFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
