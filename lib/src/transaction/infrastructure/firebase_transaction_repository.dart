import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/infrastructure/goal_mapper.dart';
import 'package:track_my_money/src/transaction/domain/i_transaction_repository.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/transaction/infrastructure/transaction_mapper.dart';

class FirebaseTransactionRepository implements ITransactionRepository {
  const FirebaseTransactionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('transactions');

  @override
  Future<Either<Failure, List<Transaction>>> findByUserCodeAndDateRange(
    String userCode, {
    required DateTime startDate,
    required DateTime endDate,
    List<int> typeIds = const <int>[],
    List<String> categoryCodes = const <String>[],
  }) async {
    Query<Map<String, dynamic>> query = _collection
        .where('userCode', isEqualTo: userCode)
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('date', descending: true);
    if (typeIds.isNotEmpty && categoryCodes.isNotEmpty) {
      query = query
          .where('categoryCode', whereIn: typeIds)
          .where('typeId', whereIn: typeIds);
    } else if (typeIds.isNotEmpty) {
      query = query.where('typeId', whereIn: typeIds);
    } else if (categoryCodes.isNotEmpty) {
      query = query.where('categoryCode', whereIn: categoryCodes);
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    return Right(
      snapshot.docs
          .map((doc) => TransactionMapper.fromQueryDocumentSnapshot(doc))
          .toList(),
    );
  }

  @override
  Future<Either<Failure, Transaction>> save(
    Transaction transaction, {
    List<Goal> goals = const <Goal>[],
  }) async {
    final WriteBatch batch = _firestore.batch();
    for (final Goal goal in goals) {
      batch.update(
        _firestore.collection('goals').doc(goal.code),
        GoalMapper.toJson(goal),
      );
    }
    batch.set(
      _collection.doc(transaction.code),
      TransactionMapper.toJson(transaction),
    );
    await batch.commit();
    return Right(transaction);
  }

  @override
  Future<Either<Failure, Transaction>> update(Transaction transaction) async {
    await _collection
        .doc(transaction.code)
        .update(TransactionMapper.toJson(transaction));
    return Right(transaction);
  }

  @override
  Future<Either<Failure, Transaction>> delete(Transaction transaction) async {
    await _collection.doc(transaction.code).delete();
    return Right(transaction);
  }
}
