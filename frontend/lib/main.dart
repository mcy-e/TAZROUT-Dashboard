//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';

//& Router Configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeShell(),
    ),
  ],
);

//& App Entry Point
void main() {
  runApp(const ProviderScope(child: TazroutApp()));
}

//& TazroutApp Widget
class TazroutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      title: 'Tazrout',
      //* Default to dark theme as per design spec
      themeMode: ThemeMode.dark,
    );
  }
}

//& HomeShell Stub
class HomeShell extends StatelessWidget {
  //? Temporary placeholder  will be replaced by NavigationShell
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Tazrout Shell'),
      ),
    );
  }
}
