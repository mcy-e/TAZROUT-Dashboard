//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';

//& App Entry Point
Future<void> main() async {
  //* Ensure Flutter binding is ready before any async work
  WidgetsFlutterBinding.ensureInitialized();
  //* Mark new session in log file
  await AppLogger.startSession();
  //* Log app launch
  AppLogger.info('MAIN', 'Tazrout Dashboard starting...');
  runApp(const ProviderScope(child: TazroutApp()));
}

//& TazroutApp Widget
class TazroutApp extends StatelessWidget {
  //* Constructor for TazroutApp
  const TazroutApp({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns MaterialApp using routerConfig from AppRouter
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      title: 'Tazrout',
      //* Default to dark theme as per design spec
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
