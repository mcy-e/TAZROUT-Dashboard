//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/sleep_provider.dart';

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
class TazroutApp extends ConsumerStatefulWidget {
  //* Constructor for TazroutApp
  const TazroutApp({super.key});

  @override
  ConsumerState<TazroutApp> createState() => _TazroutAppState();
}

class _TazroutAppState extends ConsumerState<TazroutApp> {
  @override
  void initState() {
    super.initState();
    //* Apply saved preferences on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(preferencesProvider);
      //* Apply theme
      ref.read(themeModeProvider.notifier).state =
          prefs.theme == 'Dark' ? ThemeMode.dark : ThemeMode.light;
      //* Apply locale
      final localeMap = {'en': 'en', 'fr': 'fr', 'ar': 'ar'};
      ref.read(localeProvider.notifier).state =
          Locale(localeMap[prefs.language] ?? 'en');
      //* Sleep timer duration
      ref.read(sleepTimerDurationProvider.notifier).state =
          Duration(minutes: prefs.sleepTimerMinutes);
    });
  }

  @override
  Widget build(BuildContext context) {
    //* Watch theme provider ,rebuilds app on theme change
    final themeMode = ref.watch(themeModeProvider);
    //* Watch locale provider
    final locale = ref.watch(localeProvider);
    final prefs = ref.watch(preferencesProvider);

    //* Returns MaterialApp using routerConfig from AppRouter
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //* Layout always LTR; Arabic uses textDirection on Text widgets.
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(prefs.fontScaleFactor),
            ),
            child: child!,
          ),
        );
      },
      title: 'Tazrout',
      debugShowCheckedModeBanner: false,
    );
  }
}
