import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';

class TransactionMapper {
  const TransactionMapper._();

  static Transaction fromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> query,
  ) {
    final Map<String, dynamic> data = query.data();
    return Transaction(
      amount: double.parse(data['amount'].toString()),
      categoryCode: data['categoryCode'] as String,
      code: data['code'] as String,
      createdAt: DateTime.parse(data['createdAt'].toString()),
      date: DateTime.parse(data['date'].toString()),
      description: data['description'] as String?,
      type: TypeEnum.fromId(data['typeId'] as int),
      updatedAt: DateTime.parse(data['updatedAt'].toString()),
      userCode: data['userCode'] as String,
    );
  }

  static Map<String, dynamic> toJson(Transaction transaction) {
    return {
      'amount': transaction.amount,
      'categoryCode': transaction.categoryCode,
      'code': transaction.code,
      'createdAt': transaction.createdAt.toIso8601String(),
      'date': transaction.date.toIso8601String(),
      'description': transaction.description,
      'id': transaction.id,
      'typeId': transaction.type.id,
      'updatedAt': transaction.updatedAt.toIso8601String(),
      'userCode': transaction.userCode,
    };
  }
}
