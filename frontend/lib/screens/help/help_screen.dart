//& Imports
import 'package:flutter/material.dart';

//? Stub for HelpScreen. Full implementation added in next session.
//& HelpScreen Class
class HelpScreen extends StatelessWidget {
  //* Const constructor for HelpScreen
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Help',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
