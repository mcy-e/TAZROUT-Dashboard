//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';

//& Navigation Providers
//? Controls the sidebar expanded/collapsed state
final sidebarExpandedProvider = StateProvider<bool>((ref) => true);

//? Indicates if there is an active emergency alert
final hasEmergencyAlertProvider = StateProvider<bool>((ref) => false);

// TODO :: wire emergency provider to real WebSocket events
