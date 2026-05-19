//? Represents a single WebSocket frame received from the Spring Boot backend.
//? The backend wraps every MQTT message in this envelope before forwarding.
//? Payload is a raw JSON string — callers must jsonDecode it.

//& Imports
import 'dart:convert';

//& WsFrame Model
class WsFrame {
  final String topic;
  final String timestamp;
  final String payload;

  const WsFrame({
    required this.topic,
    required this.timestamp,
    required this.payload,
  });

  factory WsFrame.fromJson(Map<String, dynamic> json) {
    return WsFrame(
      topic: json['topic'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      payload: json['payload'] as String? ?? '{}',
    );
  }

  //* Decode payload into a parsed map for callers that need it
  Map<String, dynamic> get decodedPayload {
    try {
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
