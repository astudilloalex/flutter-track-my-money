import 'package:equatable/equatable.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class GoogleSignInEvent extends SignInEvent {
  const GoogleSignInEvent();
}
