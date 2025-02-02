import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class AuthMiddleware extends ChangeNotifier {
  AuthMiddleware(this.authService) {
    _subscription = authService.authStateChanges().listen((result) {
      result.fold(
        (failure) {
          _loggedIn = false;
          _currentUser = null;
        },
        (user) {
          _loggedIn = true;
          _currentUser = user;
        },
      );
      notifyListeners();
    });
  }

  final AuthService authService;
  late final StreamSubscription<Either<Failure, User>> _subscription;
  bool _loggedIn = true;
  User? _currentUser;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool get loggedIn => _loggedIn;
  User? get currentUser => _currentUser;
}
