//? Provider for managing agricultural zones state.
//? Holds the current list of zones and their real-time sensor/device states.
//? Populated from tazrout/dashboard/summary (zone list) and
//? tazrout/zones/{zoneId}/sensors (live sensor readings per zone).

//& Imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/mqtt_topics.dart';
import '../core/utils/app_logger.dart';
import '../models/ws_frame.dart';
import '../models/zone_model.dart';
import '../services/web_socket_service.dart';

//& ZoneNotifier Class
class ZoneNotifier extends Notifier<List<ZoneModel>> {
  StreamSubscription<WsFrame>? _sub;

  @override
  List<ZoneModel> build() {
    final wsService = ref.watch(webSocketServiceProvider);
    _sub?.cancel();
    _sub = wsService.frames.listen(_handleFrame);
    ref.onDispose(() => _sub?.cancel());
    //* Starts empty — populated as WS frames arrive
    return [];
  }

  void _handleFrame(WsFrame frame) {
    try {
      if (frame.topic == MqttTopics.dashboardSummary) {
        //* Full zone list snapshot from backend ZoneService
        final json = jsonDecode(frame.payload) as Map<String, dynamic>;
        final items = json['zones'] as List?;
        if (items == null) return;
        final incoming = items
            .cast<Map<String, dynamic>>()
            .map(ZoneModel.fromSummaryJson)
            .toList();
        //* Preserve sensor readings already cached from sensor frames
        final existing = {for (final z in state) z.zoneId: z};
        state = incoming.map((z) {
          final prev = existing[z.zoneId];
          if (prev == null) return z;
          
          //? IMPORTANT: Preserve the online and valve states if they were updated by live frames
          //? This prevents the summary (which may be lagging) from flickering zones back to offline.
          return z.copyWith(
            isOnline: z.isOnline || prev.isOnline,
            isValveOpen: z.isValveOpen || prev.isValveOpen,
            temperature: prev.temperature != 0.0 ? prev.temperature : z.temperature,
            moisture: prev.moisture != 0.0 ? prev.moisture : z.moisture,
            waterLevel: prev.waterLevel != 0.0 ? prev.waterLevel : z.waterLevel,
          );
        }).toList();
      } else if (MqttTopics.isZoneSensorTopic(frame.topic)) {
        //* Per-zone sensor reading — merge onto existing zone snapshot
        final json = jsonDecode(frame.payload) as Map<String, dynamic>;
        final zoneId = MqttTopics.zoneIdFrom(frame.topic);
        final sensors = json['sensors'] as Map<String, dynamic>?;
        if (sensors == null) return;
        state = state.map((z) {
          if (z.zoneId != zoneId) return z;
          //* If we receive a sensor reading, the device is definitely online!
          return z.withSensorJson(sensors).copyWith(isOnline: true);
        }).toList();
      }
    } catch (e, st) {
      AppLogger.error('ZONE', 'Frame handle failed', e, st);
    }
  }

  //* Closes all valves instantly
  //* Used primarily during emergency stops (does NOT force devices offline)
  void setAllZonesOffline() {
    state = state.map((zone) {
      return zone.copyWith(isValveOpen: false);
    }).toList();
  }
}

//& Provider instance
final zonesProvider = NotifierProvider<ZoneNotifier, List<ZoneModel>>(() {
  return ZoneNotifier();
});
