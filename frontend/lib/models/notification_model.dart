//? Represents a single in-app notification event.

//& Notification Type Enum
enum NotificationType { sensorAlert, aiDecision }

//& Notification Model
class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
  });
}
