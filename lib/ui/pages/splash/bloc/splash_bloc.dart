import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/user/domain/user.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_event.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_state.dart';
import 'package:track_my_money/ui/routes/route_name.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required this.authService,
  }) : super(const SplashState()) {
    log('SplashBloc created', name: 'Bloc');
    on<InitialSplashEvent>(_init);
    // Init data
    add(const InitialSplashEvent());
  }

  final AuthService authService;

  @override
  Future<void> close() {
    log('SplashBloc closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _init(
    InitialSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    final Either<Failure, User> result = await authService.currentUser;
    result.fold(
      (failure) {
        emit(state.copyWith(nextRoute: RouteName.signIn));
      },
      (data) {
        emit(state.copyWith(nextRoute: RouteName.home));
      },
    );
  }
}
