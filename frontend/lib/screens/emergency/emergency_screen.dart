//& Imports
import 'package:flutter/material.dart';

//? Stub for EmergencyScreen. Full implementation added in next session.
//& EmergencyScreen Class
class EmergencyScreen extends StatelessWidget {
  //* Const constructor for EmergencyScreen
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Emergency',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
