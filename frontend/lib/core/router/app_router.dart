//& Imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/zones',
            builder: (context, state) => const ZonesScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/emergency',
            builder: (context, state) => const EmergencyScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/help',
            builder: (context, state) => const HelpScreen(),
          ),
          GoRoute(
            path: '/manual',
            builder: (context, state) => const UserManualScreen(),
          ),
        ],
      ),
    ],
  );
}
