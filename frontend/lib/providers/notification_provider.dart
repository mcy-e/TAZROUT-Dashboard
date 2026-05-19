//? Manages the queue of active notifications.
//? Notifications are added by event sources and removed on dismiss
//? or after auto-dismiss timeout.
//? Wired to receive notifications and alerts from MQTT.

//& Imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/mqtt_topics.dart';
import '../core/utils/app_logger.dart';
import '../models/notification_model.dart';
import '../models/ws_frame.dart';
import '../services/web_socket_service.dart';

//& Notification Notifier
class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  StreamSubscription<WsFrame>? _sub;
  final Ref ref;

  NotificationNotifier(this.ref) : super([]) {
    _init();
  }

  void _init() {
    final wsService = ref.watch(webSocketServiceProvider);
    _sub = wsService.frames.listen(_handleFrame);
  }

  void _handleFrame(WsFrame frame) {
    try {
      if (frame.topic == MqttTopics.dashboardNotifications ||
          frame.topic == MqttTopics.systemEmergencyAlert ||
          frame.topic == MqttTopics.aiAlerts) {
        
        final json = jsonDecode(frame.payload) as Map<String, dynamic>;
        
        final String typeStr = json['type'] as String? ?? '';
        final NotificationType type;
        if (frame.topic == MqttTopics.systemEmergencyAlert || frame.topic == MqttTopics.aiAlerts || typeStr.toUpperCase() == 'ALERT') {
          type = NotificationType.sensorAlert;
        } else if (typeStr.toUpperCase() == 'AIDECISION') {
          type = NotificationType.aiDecision;
        } else {
          type = NotificationType.sensorAlert;
        }

        final notif = NotificationModel(
          id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
          type: type,
          title: json['title'] as String? ?? 'Notification',
          message: json['message'] as String? ?? '',
          timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
        );

        add(notif);
      }
    } catch (e, st) {
      AppLogger.error('NOTIFY', 'Frame parse error', e, st);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  //& Add Notification
  //* Prepends new notification to the list
  void add(NotificationModel notification) {
    if (state.any((n) => n.id == notification.id)) {
      return; // Ignore duplicate
    }
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
  (ref) => NotificationNotifier(ref),
);

