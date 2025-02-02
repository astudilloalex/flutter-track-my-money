import 'package:equatable/equatable.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props {
    return [];
  }
}

final class InitialSplashEvent extends SplashEvent {
  const InitialSplashEvent();
}
