import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:track_my_money/app/middlewares/auth_middleware.dart';
import 'package:track_my_money/firebase_options.dart';
import 'package:track_my_money/injection.dart';
import 'package:track_my_money/ui/routes/route_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Injection.registerDependencies();
  runApp(
    MyApp(
      router: RoutePage(
        authMiddleware: getIt<AuthMiddleware>(),
      ).router,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.router,
  });

  final GoRouter router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
