import 'package:equatable/equatable.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.error = '',
    this.isLoading = false,
    this.nextRoute = '',
  });

  final String error;
  final bool isLoading;
  final String nextRoute;

  @override
  List<Object?> get props {
    return [
      error,
      isLoading,
      nextRoute,
    ];
  }

  SignInState copyWith({
    String? error,
    bool? isLoading,
    String? nextRoute,
  }) {
    return SignInState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}
