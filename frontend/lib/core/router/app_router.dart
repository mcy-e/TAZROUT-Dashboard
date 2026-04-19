//& Imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/preferences_provider.dart';
import '../../widgets/common/app_sidebar.dart';
import '../../widgets/common/notification_overlay.dart';
import '../../widgets/common/activity_detector.dart';
import '../../widgets/common/sleep_overlay.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/zones/zones_screen.dart';
import '../../screens/analytics/analytics_screen.dart';
import '../../screens/emergency/emergency_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/help/help_screen.dart';
import '../../screens/manual/user_manual_screen.dart';

//& AppRouter Class
class AppRouter {
  //? Global navigator key for referencing the navigator
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  //* Helper to build transition pages respecting Power Saving Mode
  static CustomTransitionPage _buildPageWithTransition(
      BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Consumer(
          builder: (context, ref, childWidget) {
            final animDuration = ref.watch(preferencesProvider).animDuration;
            if (animDuration == Duration.zero) return childWidget!; // Power saving instant snap

            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeIn).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: childWidget,
                ),
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  //* Router configuration
  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      //* Shell Route for Sidebar + Content
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ActivityDetector(
            child: Scaffold(
              body: Stack(
                children: [
                  //* Main content row
                  Row(
                    children: [
                      const AppSidebar(),
                      Expanded(child: child),
                    ],
                  ),
                  //* Notification overlay — sits above all content
                  const NotificationOverlay(),
                  //* Sleep overlay — topmost layer
                  const SleepOverlay(),
                ],
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const HomeScreen()),
          ),
          GoRoute(
            path: '/zones',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const ZonesScreen()),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const AnalyticsScreen()),
          ),
          GoRoute(
            path: '/emergency',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const EmergencyScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const SettingsScreen()),
          ),
          GoRoute(
            path: '/help',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const HelpScreen()),
          ),
          GoRoute(
            path: '/manual',
            pageBuilder: (context, state) => _buildPageWithTransition(context, state, const UserManualScreen()),
          ),
        ],
      ),
    ],
  );
}
