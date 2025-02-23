import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_my_money/app/middlewares/auth_middleware.dart';
import 'package:track_my_money/injection.dart';
import 'package:track_my_money/src/auth/application/auth_service.dart';
import 'package:track_my_money/src/category/application/category_service.dart';
import 'package:track_my_money/src/goal/application/goal_service.dart';
import 'package:track_my_money/src/transaction/application/transaction_service.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_bloc.dart';
import 'package:track_my_money/ui/pages/category/category_page.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:track_my_money/ui/pages/dashboard/dashboard_page.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_bloc.dart';
import 'package:track_my_money/ui/pages/goal/goal_page.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/home_page.dart';
import 'package:track_my_money/ui/pages/setting/setting_page.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:track_my_money/ui/pages/sign_in/sign_in_page.dart';
import 'package:track_my_money/ui/pages/splash/bloc/splash_bloc.dart';
import 'package:track_my_money/ui/pages/splash/splash_page.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_bloc.dart';
import 'package:track_my_money/ui/pages/transaction/transaction_page.dart';
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
            final int currentIndex = switch (state.fullPath) {
              RouteName.dashboard => 0,
              RouteName.goal => 3,
              RouteName.setting => 4,
              RouteName.transaction => 1,
              _ => 0,
            };
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeBloc(
                    categoryService: getIt<CategoryService>(),
                    transactionService: getIt<TransactionService>(),
                    currentTab: currentIndex,
                  ),
                ),
                BlocProvider(
                  create: (context) => TransactionBloc(
                    transactionService: getIt<TransactionService>(),
                    categoryService: getIt<CategoryService>(),
                  ),
                ),
              ],
              child: HomePage(child: child),
            );
          },
          routes: [
            GoRoute(
              path: RouteName.dashboard,
              builder: (context, state) => BlocProvider(
                create: (context) => DashboardBloc(
                  transactions: context.read<HomeBloc>().state.transactions,
                ),
                child: const DashboardPage(),
              ),
              parentNavigatorKey: homeNavigatorKey,
            ),
            GoRoute(
              path: RouteName.goal,
              builder: (context, state) => BlocProvider(
                create: (context) => GoalBloc(
                  goalService: getIt<GoalService>(),
                ),
                child: const GoalPage(),
              ),
              parentNavigatorKey: homeNavigatorKey,
            ),
            GoRoute(
              path: RouteName.setting,
              builder: (context, state) => const SettingPage(),
              parentNavigatorKey: homeNavigatorKey,
            ),
            GoRoute(
              path: RouteName.transaction,
              builder: (context, state) => const TransactionPage(),
              parentNavigatorKey: homeNavigatorKey,
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: navigatorKey,
          path: RouteName.category,
          builder: (context, state) => BlocProvider(
            create: (context) => CategoryBloc(
              categoryService: getIt<CategoryService>(),
            ),
            child: const CategoryPage(),
          ),
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
