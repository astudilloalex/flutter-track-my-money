import 'package:flutter/foundation.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class Budget {
  const Budget({
    required this.amount,
    this.category,
    required this.categoryCode,
    required this.createdAt,
    this.code = '',
    required this.endDate,
    this.id = 0,
    required this.startDate,
    required this.updatedAt,
    this.user,
    required this.userCode,
  });

  final double amount;
  final Category? category;
  final String categoryCode;
  final DateTime createdAt;
  final String code;
  final DateTime endDate;
  final int id;
  final DateTime startDate;
  final DateTime updatedAt;
  final User? user;
  final String userCode;

  Budget copyWith({
    double? amount,
    Category? category,
    String? categoryCode,
    DateTime? createdAt,
    String? code,
    DateTime? endDate,
    int? id,
    DateTime? startDate,
    DateTime? updatedAt,
    User? user,
    String? userCode,
  }) {
    return Budget(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      categoryCode: categoryCode ?? this.categoryCode,
      createdAt: createdAt ?? this.createdAt,
      code: code ?? this.code,
      endDate: endDate ?? this.endDate,
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userCode: userCode ?? this.userCode,
    );
  }
}
