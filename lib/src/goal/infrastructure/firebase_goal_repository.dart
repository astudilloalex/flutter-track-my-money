import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/goal_type_enum.dart';
import 'package:track_my_money/src/goal/domain/i_goal_repository.dart';
import 'package:track_my_money/src/goal/infrastructure/goal_mapper.dart';

class FirebaseGoalRepository implements IGoalRepository {
  const FirebaseGoalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('goals');

  @override
  Future<Either<Failure, List<Goal>>> findByUserCodeAndDateRange(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> query = await _collection
        .where('userCode', isEqualTo: userCode)
        .where('deadline', isGreaterThanOrEqualTo: startDate)
        .where('deadline', isLessThanOrEqualTo: endDate)
        .orderBy('deadline')
        .get();
    return Right(
      query.docs
          .map((doc) => GoalMapper.fromQueryDocumentSnapshot(doc))
          .toList(),
    );
  }

  @override
  Future<Either<Failure, Goal>> save(Goal goal) async {
    final AggregateQuerySnapshot query = await _collection
        .where(
          'userCode',
          isEqualTo: goal.userCode,
        )
        .where(
          'deadline',
          isGreaterThanOrEqualTo: DateTime.now().toIso8601String(),
        )
        .count()
        .get();
    if (query.count != null && query.count! >= 20) {
      return const Left(
        FirebaseFailure(failureEnum: FailureEnum.theGoalLimitHasBeenReached),
      );
    }
    await _collection.doc(goal.code).set(GoalMapper.toJson(goal));
    return Right(goal);
  }

  @override
  Future<Either<Failure, Goal>> update(Goal goal) async {
    await _collection.doc(goal.code).update(GoalMapper.toJson(goal));
    return Right(goal);
  }

  @override
  Stream<Either<Failure, List<Goal>>> findByUserCodeAndDateRangeStream(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _collection
        .where('userCode', isEqualTo: userCode)
        .where('deadline', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('deadline', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('deadline')
        .snapshots()
        .map(
      (query) {
        return Right(
          query.docs
              .map((doc) => GoalMapper.fromQueryDocumentSnapshot(doc))
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<Goal>>> findByUserCodeAndFromDateAndType(
    String userCode, {
    required DateTime fromDate,
    GoalTypeEnum goalType = GoalTypeEnum.automatic,
    int limit = 10,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> goalCollection = await _collection
        .where('userCode', isEqualTo: userCode)
        .where('deadline', isGreaterThanOrEqualTo: fromDate.toIso8601String())
        .where('goalTypeId', isEqualTo: goalType.id)
        .orderBy('deadline')
        .limit(limit)
        .get();
    return Right(
      goalCollection.docs
          .map((doc) => GoalMapper.fromQueryDocumentSnapshot(doc))
          .toList(),
    );
  }
}
