import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';

class CategoryMapper {
  const CategoryMapper._();

  static Category fromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> query,
  ) {
    final Map<String, dynamic> data = query.data();
    return Category(
      active: data['active'] as bool,
      code: query.id,
      createdAt: DateTime.parse(data['createdAt'].toString()),
      name: data['name'] as String,
      type: TypeEnum.fromId(data['typeId'] as int),
      updatedAt: DateTime.parse(data['updatedAt'].toString()),
      userCode: data['userCode'] as String,
    );
  }

  static Map<String, dynamic> toJson(Category category) {
    return {
      'active': category.active,
      'code': category.code,
      'createdAt': category.createdAt.toIso8601String(),
      'id': category.id,
      'name': category.name,
      'typeId': category.type.id,
      'updatedAt': category.updatedAt.toIso8601String(),
      'userCode': category.userCode,
    };
  }
}
