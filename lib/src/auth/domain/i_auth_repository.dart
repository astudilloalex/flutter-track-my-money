import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/user/domain/user.dart';

abstract class IAuthRepository {
  const IAuthRepository();

  Future<Either<Failure, User>> signInWithGoogle({
    String? accessToken,
    String? idToken,
    bool isWeb = false,
  });

  Stream<Either<Failure, User>> authStateChanges();

  Future<Either<Failure, User>> get currentUser;
}
