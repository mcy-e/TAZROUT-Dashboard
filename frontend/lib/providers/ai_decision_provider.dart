//? Holds the latest AI decision and the rolling decision log.
//? Fed from tazrout/ai/decisions/latest (snapshot on reconnect)
//? and tazrout/ai/decisions (each new decision as it arrives).

//& Imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/app_logger.dart';
import '../core/constants/mqtt_topics.dart';
import '../models/ai_decision_model.dart';
import '../models/ws_frame.dart';
import '../services/web_socket_service.dart';

//& AiDecisionState
class AiDecisionState {
  final AiDecisionModel? latest;
  final List<AiDecisionModel> log;

  const AiDecisionState({this.latest, this.log = const []});
}

//& AiDecisionNotifier
class AiDecisionNotifier extends StateNotifier<AiDecisionState> {
  StreamSubscription<WsFrame>? _sub;
  final Ref ref;

  AiDecisionNotifier(this.ref) : super(const AiDecisionState()) {
    final wsService = ref.read(webSocketServiceProvider);
    _sub = wsService.frames.listen(_handleFrame);
  }

  void _handleFrame(WsFrame frame) {
    try {
      if (frame.topic == MqttTopics.aiDecisionsLatest) {
        //* Backend AiDecisionService publishes {items:[...]} on reconnect
        final json = jsonDecode(frame.payload) as Map<String, dynamic>;
        final items = json['items'] as List?;
        if (items == null || items.isEmpty) return;
        final models = items
            .cast<Map<String, dynamic>>()
            .map(AiDecisionModel.fromJson)
            .toList();
        state = AiDecisionState(latest: models.first, log: models);
      } else if (frame.topic == MqttTopics.aiDecisions) {
        //* Single new decision arriving from AI engine
        final json = jsonDecode(frame.payload) as Map<String, dynamic>;
        final decision = AiDecisionModel.fromJson(json);
        final updatedLog = [decision, ...state.log].take(100).toList();
        state = AiDecisionState(latest: decision, log: updatedLog);
      }
    } catch (e, st) {
      AppLogger.error('AI_DECISION', 'Frame parse failed', e, st);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

//& Provider
final aiDecisionProvider =
    StateNotifierProvider<AiDecisionNotifier, AiDecisionState>((ref) {
  return AiDecisionNotifier(ref);
});
