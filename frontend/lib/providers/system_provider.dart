//? Provider for SystemRepository and its actions.
//? Enables UI components to trigger system-level commands.

//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/system_repository.dart';

//& Providers
//* Provider for the SystemRepository instance
final systemRepositoryProvider = Provider<SystemRepository>((ref) {
  return SystemRepository();
});

//* Provider for system control actions (could be expanded to a StateNotifier if state tracking is needed)
final systemControlsProvider = Provider((ref) {
  return ref.watch(systemRepositoryProvider);
});
