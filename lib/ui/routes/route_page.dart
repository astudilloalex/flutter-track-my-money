import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_my_money/app/middlewares/auth_middleware.dart';
import 'package:track_my_money/injection.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/ui/pages/dashboard/dashboard_page.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/home_page.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:track_my_money/ui/pages/sign_in/sign_in_page.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_bloc.dart';
import 'package:track_my_money/ui/pages/splash/splash_page.dart';
import 'package:track_my_money/ui/routes/route_name.dart';

class RoutePage {
  const RoutePage({
    required this.authMiddleware,
  });

  final AuthMiddleware authMiddleware;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();

  GoRouter get router {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: RouteName.splash,
      redirect: (context, state) {
        if (!authMiddleware.loggedIn) {
          if (state.matchedLocation == RouteName.signIn ||
              state.matchedLocation == RouteName.splash) {
            return null;
          }
          return RouteName.signIn;
        }
        if (state.matchedLocation == RouteName.home) {
          return RouteName.dashboard;
        }
        return null;
      },
      routes: [
        ShellRoute(
          navigatorKey: homeNavigatorKey,
          builder: (context, state, child) {
            return BlocProvider(
              create: (context) => HomeBloc(),
              child: HomePage(
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              path: RouteName.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        GoRoute(
          path: RouteName.signIn,
          builder: (context, state) => BlocProvider(
            create: (context) => SignInBloc(
              authService: getIt<AuthService>(),
            ),
            child: const SignInPage(),
          ),
        ),
        GoRoute(
          path: RouteName.splash,
          builder: (context, state) => BlocProvider(
            create: (context) => SplashBloc(
              authService: getIt<AuthService>(),
            ),
            child: const SplashPage(),
          ),
        ),
      ],
    );
  }
}
