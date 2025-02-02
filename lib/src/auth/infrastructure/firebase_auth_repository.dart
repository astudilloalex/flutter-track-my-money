import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/user/domain/user.dart';
import 'package:track_my_money/src/user/infrastructure/user_mapper.dart';

class FirebaseAuthRepository implements IAuthRepository {
  const FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<Failure, User>> signInWithGoogle({
    String? accessToken,
    String? idToken,
    bool isWeb = false,
  }) async {
    final UserCredential userCredential;
    if (isWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      userCredential =
          await _firebaseAuth.signInWithCredential(oAuthCredential);
    }
    if (userCredential.user == null) {
      return const Left(
        FirebaseFailure(
          failureEnum: FailureEnum.userNotFound,
        ),
      );
    }
    return Right(UserMapper.fromFirebaseUser(userCredential.user!));
  }

  @override
  Stream<Either<Failure, User>> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return const Left(
          FirebaseFailure(
            failureEnum: FailureEnum.theSessionHasBeenClosed,
          ),
        );
      }
      return Right(UserMapper.fromFirebaseUser(user));
    });
  }

  @override
  Future<Either<Failure, User>> get currentUser async {
    if (_firebaseAuth.currentUser == null) {
      return const Left(
        FirebaseFailure(
          failureEnum: FailureEnum.userNotFound,
        ),
      );
    }
    return Right(UserMapper.fromFirebaseUser(_firebaseAuth.currentUser!));
  }
}
