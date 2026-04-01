//? Home screen layout — composes all home widgets.
//? Does not contain any widget implementation.

//& Imports
import 'package:flutter/material.dart';
import 'widgets/system_controls_card.dart';
import 'widgets/welcome_card.dart';
import 'widgets/did_you_know_card.dart';
import 'widgets/performance_monitor_card.dart';
import 'widgets/clock_widget.dart';
import 'widgets/calendar_widget.dart';

//& HomeScreen Widget
class HomeScreen extends StatelessWidget {
  //* StatelessWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Use LayoutBuilder to get parent constraints
    //* Then use SizedBox with explicit heights based on available space
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            //* Reserve 200px for top row, rest goes to bottom area
            const double topRowHeight = 200;
            const double gap = 16;
            final double bottomHeight =
                constraints.maxHeight - topRowHeight - gap;

            return Column(
              children: [
                //* Top row — 3 equal cards
                SizedBox(
                  height: topRowHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(flex: 1, child: SystemControlsCard()),
                      const SizedBox(width: 12),
                      const Expanded(flex: 2, child: WelcomeCard()),
                      const SizedBox(width: 12),
                      const Expanded(flex: 1, child: DidYouKnowCard()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                //* Bottom area — performance monitor + right column
                SizedBox(
                  height: bottomHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(flex: 3, child: PerformanceMonitorCard()),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: const [
                            Expanded(child: ClockWidget()),
                            SizedBox(height: 16),
                            Expanded(child: CalendarWidget()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
