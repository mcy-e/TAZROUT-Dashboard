//& Imports
import 'package:flutter/material.dart';

//? Stub for ZonesScreen. Full implementation added in next session.
//& ZonesScreen Class
class ZonesScreen extends StatelessWidget {
  //* Const constructor for ZonesScreen
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* Returns a centered text with headlineMedium style
    return Center(
      child: Text(
        'Zones',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
