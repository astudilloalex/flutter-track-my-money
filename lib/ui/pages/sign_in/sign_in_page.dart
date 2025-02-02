import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_state.dart';
import 'package:track_my_money/ui/pages/sign_in/widgets/sign_in_google_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.isLoading) {
          context.loaderOverlay.show();
          return;
        }
        if (!state.isLoading) {
          context.loaderOverlay.hide();
        }
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
          return;
        }
        if (state.nextRoute.isNotEmpty) {
          context.go(state.nextRoute);
        }
      },
      child: const Scaffold(
        body: SafeArea(
          child: Center(
            child: SignInGoogleButton(),
          ),
        ),
      ),
    );
  }
}
