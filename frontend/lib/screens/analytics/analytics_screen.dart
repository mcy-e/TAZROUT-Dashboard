//& Imports
import 'package:flutter/material.dart';

//? Stub for AnalyticsScreen. Full implementation added in next session.
//& AnalyticsScreen Class
class AnalyticsScreen extends StatelessWidget {
  //* Const constructor for AnalyticsScreen
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Analytics',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
