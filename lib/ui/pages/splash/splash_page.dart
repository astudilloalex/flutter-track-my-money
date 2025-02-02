import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:track_my_money/app/asset/lottie_asset.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_bloc.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state.nextRoute.isNotEmpty) {
          context.go(state.nextRoute);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Lottie.asset(
              LottieAsset.loading.name,
              width: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}
