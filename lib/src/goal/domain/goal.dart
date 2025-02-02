import 'package:track_my_money/src/user/domain/user.dart';

class Goal {
  const Goal({
    this.code = '',
    required this.createdAt,
    this.currentAmount = 0,
    required this.deadline,
    this.id = 0,
    required this.name,
    this.targetAmount = 1000,
    required this.updatedAt,
    this.user,
    required this.userCode,
  });

  final String code;
  final DateTime createdAt;
  final double currentAmount;
  final DateTime deadline;
  final int id;
  final String name;
  final double targetAmount;
  final DateTime updatedAt;
  final User? user;
  final String userCode;

  Goal copyWith({
    String? code,
    DateTime? createdAt,
    double? currentAmount,
    DateTime? deadline,
    int? id,
    String? name,
    double? targetAmount,
    DateTime? updatedAt,
    User? user,
    String? userCode,
  }) {
    return Goal(
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userCode: userCode ?? this.userCode,
    );
  }
}
