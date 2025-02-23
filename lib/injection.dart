import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:track_my_money/app/middlewares/auth_middleware.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/auth/domain/i_auth_repository.dart';
import 'package:track_my_money/src/auth/infrastructure/firebase_auth_repository.dart';
import 'package:track_my_money/src/category/application/category_service.dart';
import 'package:track_my_money/src/category/domain/i_category_repository.dart';
import 'package:track_my_money/src/category/infrastructure/firebase_category_repository.dart';
import 'package:track_my_money/src/goal/application/goal_service.dart';
import 'package:track_my_money/src/goal/domain/i_goal_repository.dart';
import 'package:track_my_money/src/goal/infrastructure/firebase_goal_repository.dart';
import 'package:track_my_money/src/transaction/application/transaction_service.dart';
import 'package:track_my_money/src/transaction/domain/i_transaction_repository.dart';
import 'package:track_my_money/src/transaction/infrastructure/firebase_transaction_repository.dart';
import 'package:track_my_money/src/user/domain/i_user_repository.dart';
import 'package:track_my_money/src/user/infrastructure/firebase_user_repository.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  const Injection._();

  static Future<void> registerDependencies() async {
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }

    // Repositories
    getIt.registerLazySingleton<IAuthRepository>(
      () => FirebaseAuthRepository(FirebaseAuth.instance),
    );
    getIt.registerLazySingleton<ICategoryRepository>(
      () => FirebaseCategoryRepository(FirebaseFirestore.instance),
    );
    getIt.registerLazySingleton<IGoalRepository>(
      () => FirebaseGoalRepository(FirebaseFirestore.instance),
    );
    getIt.registerLazySingleton<IUserRepository>(
      () => FirebaseUserRepository(FirebaseFirestore.instance),
    );
    getIt.registerLazySingleton<ITransactionRepository>(
      () => FirebaseTransactionRepository(FirebaseFirestore.instance),
    );

    // Services
    getIt.registerFactory<AuthService>(
      () => AuthService(
        getIt<IAuthRepository>(),
        userRepository: getIt<IUserRepository>(),
      ),
    );
    getIt.registerFactory<CategoryService>(
      () => CategoryService(
        getIt<ICategoryRepository>(),
        authRepository: getIt<IAuthRepository>(),
      ),
    );
    getIt.registerFactory<GoalService>(
      () => GoalService(
        getIt<IGoalRepository>(),
        authRepository: getIt<IAuthRepository>(),
      ),
    );
    getIt.registerFactory(
      () => TransactionService(
        getIt<ITransactionRepository>(),
        authRepository: getIt<IAuthRepository>(),
        goalRepository: getIt<IGoalRepository>(),
      ),
    );
    // Middlewares
    getIt.registerFactory<AuthMiddleware>(
      () => AuthMiddleware(getIt<AuthService>()),
    );
  }
}
