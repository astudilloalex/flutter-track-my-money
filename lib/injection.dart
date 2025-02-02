import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:track_my_money/app/middlewares/auth_middleware.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/auth/infrastructure/firebase_auth_repository.dart';
import 'package:track_my_money/src/user/domain/i_user_repository.dart';
import 'package:track_my_money/src/user/infrastructure/firebase_user_repository.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  const Injection._();

  static Future<void> registerDependencies() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    }

    // Repositories
    getIt.registerLazySingleton<IAuthRepository>(
      () => FirebaseAuthRepository(FirebaseAuth.instance),
    );
    getIt.registerLazySingleton<IUserRepository>(
      () => FirebaseUserRepository(FirebaseFirestore.instance),
    );

    // Services
    getIt.registerFactory<AuthService>(
      () => AuthService(
        getIt<IAuthRepository>(),
        userRepository: getIt<IUserRepository>(),
      ),
    );

    // Middlewares
    getIt.registerFactory<AuthMiddleware>(
      () => AuthMiddleware(getIt<AuthService>()),
    );
  }
}
