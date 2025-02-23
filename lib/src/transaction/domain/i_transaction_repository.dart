import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';

abstract class ITransactionRepository {
  const ITransactionRepository();

  Future<Either<Failure, List<Transaction>>> findByUserCodeAndDateRange(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
    List<int> typeIds = const <int>[],
    List<String> categoryCodes = const <String>[],
  });

  Future<Either<Failure, Transaction>> save(
    Transaction transaction, {
    List<Goal> goals = const <Goal>[],
  });

  Future<Either<Failure, Transaction>> update(Transaction transaction);

  Future<Either<Failure, Transaction>> delete(Transaction transaction);
}
