import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/app/util/string_util.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/i_goal_repository.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class GoalService {
  const GoalService(
    this._repository, {
    required this.authRepository,
  });

  final IGoalRepository _repository;
  final IAuthRepository authRepository;

  Future<Either<Failure, List<Goal>>> getByDateRange({
    required DateTime startDate,
    required DateTime endDate,
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
      return await _repository.findByUserCodeAndDateRange(
        user!.code,
        startDate: startDate.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
        endDate: endDate.copyWith(
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
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

  Future<Either<Failure, Goal>> create(Goal goal) async {
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
        goal.copyWith(
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

  Future<Either<Failure, Goal>> update(Goal goal) async {
    try {
      return await _repository.update(
        goal.copyWith(
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

  Stream<Either<Failure, List<Goal>>> getByDateRangeStream({
    required DateTime startDate,
    required DateTime endDate,
  }) async* {
    try {
      final Either<Failure, User> eitherUser = await authRepository.currentUser;
      if (eitherUser.isLeft()) {
        final Failure? failure = eitherUser.fold(
          (fail) => fail,
          (_) => null,
        );
        yield Left(failure!);
      }

      final User? user = eitherUser.fold(
        (_) => null,
        (data) => data,
      );
      yield* _repository.findByUserCodeAndDateRangeStream(
        user!.code,
        startDate: startDate.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ),
        endDate: endDate.copyWith(
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
        ),
      );
    } catch (e) {
      yield Left(
        ServiceFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
