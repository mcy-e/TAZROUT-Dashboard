//& Imports
import 'package:flutter/material.dart';

//? Stub for SettingsScreen. Full implementation added in next session.
//& SettingsScreen Class
class SettingsScreen extends StatelessWidget {
  //* Const constructor for SettingsScreen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Settings',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
