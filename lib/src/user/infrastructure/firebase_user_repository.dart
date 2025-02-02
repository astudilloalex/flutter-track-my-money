import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/user/domain/i_user_repository.dart';
import 'package:track_my_money/src/user/domain/user.dart';
import 'package:track_my_money/src/user/infrastructure/user_mapper.dart';

class FirebaseUserRepository implements IUserRepository {
  const FirebaseUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<Either<Failure, User>> findByCode(String code) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(code).get();
    if (!doc.exists) {
      return const Left(
        FirebaseFailure(
          failureEnum: FailureEnum.userNotFound,
        ),
      );
    }
    return Right(UserMapper.fromDocumentSnapshot(doc));
  }

  @override
  Future<Either<Failure, User>> save(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user.code).get();
    if (doc.exists) {
      return const Left(
        FirebaseFailure(
          failureEnum: FailureEnum.userAlreadyExists,
        ),
      );
    }
    await _firestore
        .collection('users')
        .doc(user.code)
        .set(UserMapper.toJson(user));
    return Right(user);
  }

  @override
  Future<Either<Failure, User>> update(User user) async {
    await _firestore
        .collection('users')
        .doc(user.code)
        .update(UserMapper.toJson(user));
    return Right(user);
  }

  @override
  Future<Either<Failure, User>> saveOrUpdate(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user.code).get();
    if (!doc.exists) {
      await _firestore
          .collection('users')
          .doc(user.code)
          .set(UserMapper.toJson(user));
      return Right(user);
    }
    await _firestore
        .collection('users')
        .doc(user.code)
        .update(UserMapper.toJson(user));
    return Right(user);
  }
}
