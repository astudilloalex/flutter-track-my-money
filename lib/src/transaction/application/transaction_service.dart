import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/app/util/string_util.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/i_goal_repository.dart';
import 'package:track_my_money/src/transaction/domain/i_transaction_repository.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class TransactionService {
  const TransactionService(
    this._repository, {
    required this.authRepository,
    required this.goalRepository,
  });

  final ITransactionRepository _repository;
  final IAuthRepository authRepository;
  final IGoalRepository goalRepository;

  Future<Either<Failure, List<Transaction>>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    List<int> typeIds = const <int>[],
    List<String> categoryCodes = const <String>[],
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
        startDate: startDate,
        endDate: endDate,
        typeIds: typeIds,
        categoryCodes: categoryCodes,
      );
    } catch (e) {
      return Left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  Future<Either<Failure, Transaction>> save(Transaction transaction) async {
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
      // Get goals to update the progress
      final Either<Failure, List<Goal>> eitherGoals =
          await goalRepository.findByUserCodeAndFromDateAndType(
        user!.code,
        fromDate: transaction.date,
        limit: 20,
      );
      if (eitherGoals.isLeft()) {
        final Failure? failure = eitherGoals.fold(
          (fail) => fail,
          (_) => null,
        );
        return Left(failure!);
      }
      final List<Goal> goals = _distributeGoalAmount(
        transaction,
        eitherGoals.fold(
          (_) => <Goal>[],
          (data) => data,
        ),
      );
      return await _repository.save(
        transaction.copyWith(
          code: StringUtil.generateRandomCode(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userCode: user.code,
        ),
        goals: goals,
      );
    } catch (e) {
      return Left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  Future<Either<Failure, Transaction>> update(Transaction transaction) async {
    try {
      return await _repository.save(
        transaction.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  Future<Either<Failure, Transaction>> delete(Transaction transaction) async {
    try {
      return await _repository.delete(transaction);
    } catch (e) {
      return Left(
        FirebaseFailure(message: e.toString()),
      );
    }
  }

  List<Goal> _distributeGoalAmount(Transaction transaction, List<Goal> goals) {
    Decimal remainingAmount = Decimal.parse(transaction.amount.toString());
    final List<Goal> updatedGoals = <Goal>[];
    switch (transaction.type) {
      case TypeEnum.income:
        for (final Goal goal in goals) {
          final Decimal needed = Decimal.parse(goal.targetAmount.toString()) -
              Decimal.parse(goal.currentAmount.toString());
          if (needed <= Decimal.zero) continue;
          final Decimal allocation =
              remainingAmount >= needed ? needed : remainingAmount;
          updatedGoals.add(
            goal.copyWith(
              currentAmount:
                  (Decimal.parse(goal.currentAmount.toString()) + allocation)
                      .toDouble(),
              updatedAt: DateTime.now(),
            ),
          );
          remainingAmount -= allocation;
          if (remainingAmount <= Decimal.zero) break;
        }
      case TypeEnum.expense:
        for (final Goal goal in goals.reversed) {
          final Decimal available =
              Decimal.parse(goal.currentAmount.toString());
          if (available <= Decimal.zero) continue;
          final Decimal deduction =
              remainingAmount >= available ? available : remainingAmount;
          updatedGoals.add(
            goal.copyWith(
              currentAmount:
                  (Decimal.parse(goal.currentAmount.toString()) - deduction)
                      .toDouble(),
              updatedAt: DateTime.now(),
            ),
          );
          remainingAmount -= deduction;
          if (remainingAmount <= Decimal.zero) break;
        }
    }
    return updatedGoals;
  }
}
