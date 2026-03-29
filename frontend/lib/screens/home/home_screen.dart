//& Imports
import 'package:flutter/material.dart';

//? Stub for HomeScreen. Full implementation added in next session.
//& HomeScreen Class
class HomeScreen extends StatelessWidget {
  //* Const constructor for HomeScreen
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Home',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
