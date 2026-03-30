//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'providers/theme_provider.dart';

//& App Entry Point
Future<void> main() async {
  //* Ensure Flutter binding is ready before any async work
  WidgetsFlutterBinding.ensureInitialized();
  //* Mark new session in log file
  await AppLogger.startSession();
  //* Log app launch
  AppLogger.info('MAIN', 'Tazrout Dashboard starting...');
  //* Log input type detection
  // TODO :: Detect touch vs mouse input and log via AppLogger
  AppLogger.info('INPUT', 'UI initialized for dual input mode');
  runApp(const ProviderScope(child: TazroutApp()));
}

//& TazroutApp Widget
class TazroutApp extends ConsumerWidget {
  //* Constructor for TazroutApp
  const TazroutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Watch theme provider ,rebuilds app on theme change
    final themeMode = ref.watch(themeModeProvider);
    
    //* Returns MaterialApp using routerConfig from AppRouter
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      title: 'Tazrout',
      debugShowCheckedModeBanner: false,
    );
  }
}
