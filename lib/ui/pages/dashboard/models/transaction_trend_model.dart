import 'package:track_my_money/src/type/domain/type_enum.dart';

class TransactionTrendModel {
  const TransactionTrendModel({
    required this.amount,
    required this.date,
    required this.type,
  });

  final double amount;
  final DateTime date;
  final TypeEnum type;

  TransactionTrendModel copyWith({
    double? amount,
    DateTime? date,
    TypeEnum? type,
  }) {
    return TransactionTrendModel(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }
}
