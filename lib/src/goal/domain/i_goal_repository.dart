import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/goal_type_enum.dart';

abstract class IGoalRepository {
  const IGoalRepository();

  Future<Either<Failure, List<Goal>>> findByUserCodeAndDateRange(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, List<Goal>>> findByUserCodeAndFromDateAndType(
    String userCode, {
    required DateTime fromDate,
    GoalTypeEnum goalType = GoalTypeEnum.automatic,
    int limit = 10,
  });

  Stream<Either<Failure, List<Goal>>> findByUserCodeAndDateRangeStream(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, Goal>> save(Goal goal);

  Future<Either<Failure, Goal>> update(Goal goal);
}
