import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/user/domain/user.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_event.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_state.dart';
import 'package:track_my_money/ui/routes/route_name.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required this.authService,
  }) : super(const SignInState()) {
    log('SignInBloc created', name: 'Bloc');
    on<GoogleSignInEvent>(_signInWithGoogle);
  }

  final AuthService authService;

  Future<void> _signInWithGoogle(
    GoogleSignInEvent event,
    Emitter<SignInState> emit,
  ) async {
    String nextRoute = '';
    String error = '';
    try {
      emit(
        state.copyWith(
          isLoading: true,
          nextRoute: nextRoute,
          error: error,
        ),
      );
      final Either<Failure, User> result = await authService.signInWithGoogle();
      result.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          nextRoute = RouteName.home;
        },
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            nextRoute: nextRoute,
            error: error,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    log('SignInBloc closed', name: 'Bloc');
    return super.close();
  }
}
