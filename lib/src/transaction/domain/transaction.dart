import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class Transaction {
  const Transaction({
    required this.amount,
    this.category,
    required this.categoryCode,
    this.code = '',
    required this.createdAt,
    required this.date,
    this.description,
    this.id = 0,
    required this.type,
    required this.updatedAt,
    this.user,
    required this.userCode,
  });

  final double amount;
  final Category? category;
  final String categoryCode;
  final String code;
  final DateTime createdAt;
  final DateTime date;
  final String? description;
  final int id;
  final TypeEnum type;
  final DateTime updatedAt;
  final User? user;
  final String userCode;

  Transaction copyWith({
    double? amount,
    Category? category,
    String? categoryCode,
    String? code,
    DateTime? createdAt,
    DateTime? date,
    String? description,
    int? id,
    TypeEnum? type,
    DateTime? updatedAt,
    User? user,
    String? userCode,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      categoryCode: categoryCode ?? this.categoryCode,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      date: date ?? this.date,
      description: description ?? this.description,
      id: id ?? this.id,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userCode: userCode ?? this.userCode,
    );
  }
}
