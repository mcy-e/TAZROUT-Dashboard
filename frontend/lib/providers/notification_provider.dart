//? Manages the queue of active notifications.
//? Notifications are added by event sources and removed on dismiss
//? or after auto-dismiss timeout.
// TODO :: Wire SENSOR_UPDATE events from MQTT:
// TODO ::   tazrout/zones/{zoneId}/status → triggers sensorAlert
// TODO :: Wire AI_DECISION events from MQTT:
// TODO ::   tazrout/ai/decisions → triggers aiDecision

//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../core/utils/app_logger.dart';

//& Notification Notifier
class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier() : super([]);

  //& Add Notification
  //* Prepends new notification to the list
  void add(NotificationModel notification) {
    state = [notification, ...state];
    AppLogger.info('NOTIFY', 'Notification added: ${notification.title}');
  }

  //& Remove Notification
  //* Removes by id — called on dismiss or auto-dismiss
  void remove(String id) {
    state = state.where((n) => n.id != id).toList();
    AppLogger.debug('NOTIFY', 'Notification dismissed: $id');
  }

  //& Clear All
  void clearAll() {
    state = [];
    AppLogger.info('NOTIFY', 'All notifications cleared');
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>(
  (ref) => NotificationNotifier(),
);
