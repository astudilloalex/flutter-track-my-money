import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/goal_type_enum.dart';

class GoalMapper {
  const GoalMapper._();

  static Goal fromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> query,
  ) {
    final Map<String, dynamic> data = query.data();
    return Goal(
      code: data['code'] as String,
      createdAt: DateTime.parse(data['createdAt'].toString()),
      currentAmount: double.parse(data['currentAmount'].toString()),
      deadline: DateTime.parse(data['deadline'].toString()),
      goalType: GoalTypeEnum.fromId(data['goalTypeId'] as int),
      name: data['name'] as String,
      targetAmount: double.parse(data['targetAmount'].toString()),
      updatedAt: DateTime.parse(data['updatedAt'].toString()),
      userCode: data['userCode'] as String,
    );
  }

  static Map<String, dynamic> toJson(Goal goal) {
    return {
      'code': goal.code,
      'createdAt': goal.createdAt.toIso8601String(),
      'currentAmount': goal.currentAmount,
      'deadline': goal.deadline.toIso8601String(),
      'goalTypeId': goal.goalType.id,
      'id': goal.id,
      'name': goal.name,
      'targetAmount': goal.targetAmount,
      'updatedAt': goal.updatedAt.toIso8601String(),
      'userCode': goal.userCode,
    };
  }
}
