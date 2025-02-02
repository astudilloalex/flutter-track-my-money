import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/user/domain/i_user_repository.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class AuthService {
  const AuthService(
    this._repository, {
    required this.userRepository,
  });

  final IAuthRepository _repository;
  final IUserRepository userRepository;

  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final Either<Failure, User> result;
      if (kIsWeb) {
        result = await _repository.signInWithGoogle(isWeb: true);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        result = await _repository.signInWithGoogle(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
      }
      return await result.fold(
        (failure) {
          return Left(failure);
        },
        (data) async {
          await userRepository.saveOrUpdate(data);
          return Right(data);
        },
      );
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  Stream<Either<Failure, User>> authStateChanges() {
    return _repository.authStateChanges();
  }

  Future<Either<Failure, User>> get currentUser async {
    try {
      return await _repository.currentUser;
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
