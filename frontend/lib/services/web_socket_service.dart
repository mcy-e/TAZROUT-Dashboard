//? Manages the single WebSocket connection to the Spring Boot backend.
//? The backend broadcasts every MQTT message as a {topic, timestamp, payload} frame.
//? This service parses those frames and exposes them as a broadcast stream.
//? Also handles outbound publishes — sends command frames the backend relays to MQTT.
//
// TODO :: Backend must implement WS→MQTT relay in DashboardWebSocketHandler.handleTextMessage
//         for outbound commands (system/control, emergency/stop) to reach the broker.

//& Imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/utils/app_logger.dart';
import '../models/ws_frame.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';

//& WebSocketService
class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final StreamController<WsFrame> _controller = StreamController<WsFrame>.broadcast();
  final Ref ref;

  WebSocketService(this.ref);

  Stream<WsFrame> get frames => _controller.stream;

  //* Connect to the Spring Boot WebSocket endpoint
  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      AppLogger.info('WS', 'Connected to $url');
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e, st) {
      AppLogger.error('WS', 'Connection failed', e, st);
      _triggerConnectionWarning();
    }
  }

  //* Send a command frame — backend must relay this to the MQTT broker
  void publish(String topic, Map<String, dynamic> payload) {
    try {
      final frame = jsonEncode({'topic': topic, 'payload': jsonEncode(payload)});
      _channel?.sink.add(frame);
      AppLogger.info('WS', 'Sent command on topic: $topic');
    } catch (e, st) {
      AppLogger.error('WS', 'Publish failed for $topic', e, st);
    }
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String) as Map<String, dynamic>;
      _controller.add(WsFrame.fromJson(decoded));
    } catch (e, st) {
      AppLogger.error('WS', 'Frame parse error', e, st);
    }
  }

  void _onError(Object error) {
    AppLogger.error('WS', 'WebSocket stream error', error, StackTrace.current);
    _triggerConnectionWarning();
  }
  
  void _triggerConnectionWarning() {
    // Console warning block
    AppLogger.error('WS', 'CRITICAL STARTUP FAILURE: Could not connect to Spring Boot Backend.');
    debugPrint('\n==================================================');
    debugPrint('[ERROR] CRITICAL STARTUP FAILURE');
    debugPrint('[ERROR] Flutter Dashboard failed to connect to the backend.');
    debugPrint('[ERROR] Please check:');
    debugPrint('  1. Is the Spring Boot backend running?');
    debugPrint('  2. Are you connecting to the correct port (ws://localhost:8080)?');
    debugPrint('[ERROR] The Spring Boot backend MUST be running BEFORE the frontend.');
    debugPrint('==================================================\n');

    ref.read(notificationProvider.notifier).add(
      NotificationModel(
        id: 'ws-conn-error-${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.emergency,
        title: 'Connection Failed',
        message: 'Could not connect to Backend. Is the Spring Boot server running?',
        timestamp: DateTime.now(),
      )
    );
  }

  void _onDone() {
    AppLogger.info('WS', 'WebSocket connection closed');
  }

  void dispose() {
    _subscription?.cancel();
    _channel?.sink.close();
    _controller.close();
  }
}

//& Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService(ref);
  ref.onDispose(service.dispose);
  return service;
});
