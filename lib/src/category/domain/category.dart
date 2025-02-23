import 'package:track_my_money/src/budget/domain/budget.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class Category {
  const Category({
    this.active = true,
    this.budgets = const <Budget>[],
    this.code = '',
    required this.createdAt,
    this.id = 0,
    required this.name,
    this.transactions = const <Transaction>[],
    required this.type,
    required this.updatedAt,
    required this.userCode,
    this.user,
  });

  final bool active;
  final List<Budget> budgets;
  final String code;
  final DateTime createdAt;
  final int id;
  final String name;
  final List<Transaction> transactions;
  final TypeEnum type;
  final DateTime updatedAt;
  final User? user;
  final String userCode;

  Category copyWith({
    bool? active,
    List<Budget>? budgets,
    String? code,
    DateTime? createdAt,
    int? id,
    String? name,
    List<Transaction>? transactions,
    TypeEnum? type,
    DateTime? updatedAt,
    User? user,
    String? userCode,
  }) {
    return Category(
      active: active ?? this.active,
      budgets: budgets ?? this.budgets,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      transactions: transactions ?? this.transactions,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userCode: userCode ?? this.userCode,
    );
  }
}
