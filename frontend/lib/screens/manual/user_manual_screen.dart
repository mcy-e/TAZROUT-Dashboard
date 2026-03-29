//& Imports
import 'package:flutter/material.dart';

//? Stub for UserManualScreen. Full implementation added in next session.
//& UserManualScreen Class
class UserManualScreen extends StatelessWidget {
  //* Const constructor for UserManualScreen
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'User Manual',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
