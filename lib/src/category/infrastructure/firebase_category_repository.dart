import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/category/domain/i_category_repository.dart';
import 'package:track_my_money/src/category/infrastructure/category_mapper.dart';

class FirebaseCategoryRepository implements ICategoryRepository {
  const FirebaseCategoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('categories');

  @override
  Future<Either<Failure, List<Category>>> findByUserCode(
    String userCode, {
    bool? onlyActive,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> query = onlyActive == null
        ? await _collection
            .where('userCode', isEqualTo: userCode)
            .orderBy('typeId')
            .orderBy('name')
            .get()
        : await _collection
            .where('userCode', isEqualTo: userCode)
            .where('active', isEqualTo: onlyActive)
            .orderBy('typeId')
            .orderBy('name')
            .get();
    return Right(
      query.docs
          .map(
            (doc) => CategoryMapper.fromQueryDocumentSnapshot(doc),
          )
          .toList(),
    );
  }

  @override
  Future<Either<Failure, Category>> save(Category category) async {
    final AggregateQuerySnapshot query = await _collection
        .where(
          'name',
          isEqualTo: category.name,
        )
        .where(
          'userCode',
          isEqualTo: category.userCode,
        )
        .count()
        .get();
    if (query.count != null && query.count! > 0) {
      return const Left(
        FirebaseFailure(failureEnum: FailureEnum.theCategoryAlreadyExists),
      );
    }
    await _collection.doc(category.code).set(CategoryMapper.toJson(category));
    return Right(category);
  }

  @override
  Future<Either<Failure, Category>> update(Category category) async {
    await _collection
        .doc(category.code)
        .update(CategoryMapper.toJson(category));
    return Right(category);
  }
}
