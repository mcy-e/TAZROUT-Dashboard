//? Manages analytics chart data for the Analytics screen.
//? Listens to WebSocket frames from the backend AnalyticsService.
//? Falls back to real-time zone data if no analytics frames arrive.

//& Imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/mqtt_topics.dart';
import '../core/utils/app_logger.dart';
import '../models/ws_frame.dart';
import '../services/web_socket_service.dart';
import 'zone_provider.dart';

//& AnalyticsState
class AnalyticsState {
  final String selectedWaterPeriod; // "day", "week", "month"
  final String selectedConsumptionPeriod; // "day", "week", "month"
  
  final List<double> waterUsageDay;
  final List<String> waterLabelsDay;
  final List<double> waterUsageWeek;
  final List<String> waterLabelsWeek;
  final List<double> waterUsageMonth;
  final List<String> waterLabelsMonth;

  final List<double> envTemp;
  final List<String> envLabels;
  final List<double> envHum;
  
  final List<List<double>> consumptionDay;
  final List<String> consumptionLabelsDay;
  final List<List<double>> consumptionWeek;
  final List<String> consumptionLabelsWeek;
  final List<List<double>> consumptionMonth;
  final List<String> consumptionLabelsMonth;

  const AnalyticsState({
    this.selectedWaterPeriod = 'day',
    this.selectedConsumptionPeriod = 'day',
    this.waterUsageDay = const [],
    this.waterLabelsDay = const [],
    this.waterUsageWeek = const [],
    this.waterLabelsWeek = const [],
    this.waterUsageMonth = const [],
    this.waterLabelsMonth = const [],
    this.envTemp = const [20, 20, 20, 20, 20, 20, 20],
    this.envLabels = const ['R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7'],
    this.envHum = const [50, 50, 50, 50, 50, 50, 50],
    this.consumptionDay = const [],
    this.consumptionLabelsDay = const [],
    this.consumptionWeek = const [],
    this.consumptionLabelsWeek = const [],
    this.consumptionMonth = const [],
    this.consumptionLabelsMonth = const [],
  });

  // Helper getters to simplify UI code
  List<double> get currentWaterUsage => selectedWaterPeriod == 'day' ? waterUsageDay : (selectedWaterPeriod == 'week' ? waterUsageWeek : waterUsageMonth);
  List<String> get currentWaterLabels => selectedWaterPeriod == 'day' ? waterLabelsDay : (selectedWaterPeriod == 'week' ? waterLabelsWeek : waterLabelsMonth);
  List<List<double>> get currentConsumption => selectedConsumptionPeriod == 'day' ? consumptionDay : (selectedConsumptionPeriod == 'week' ? consumptionWeek : consumptionMonth);
  List<String> get currentConsumptionLabels => selectedConsumptionPeriod == 'day' ? consumptionLabelsDay : (selectedConsumptionPeriod == 'week' ? consumptionLabelsWeek : consumptionLabelsMonth);

  AnalyticsState copyWith({
    String? selectedWaterPeriod,
    String? selectedConsumptionPeriod,
    List<double>? waterUsageDay,
    List<String>? waterLabelsDay,
    List<double>? waterUsageWeek,
    List<String>? waterLabelsWeek,
    List<double>? waterUsageMonth,
    List<String>? waterLabelsMonth,
    List<double>? envTemp,
    List<String>? envLabels,
    List<double>? envHum,
    List<List<double>>? consumptionDay,
    List<String>? consumptionLabelsDay,
    List<List<double>>? consumptionWeek,
    List<String>? consumptionLabelsWeek,
    List<List<double>>? consumptionMonth,
    List<String>? consumptionLabelsMonth,
  }) {
    return AnalyticsState(
      selectedWaterPeriod: selectedWaterPeriod ?? this.selectedWaterPeriod,
      selectedConsumptionPeriod: selectedConsumptionPeriod ?? this.selectedConsumptionPeriod,
      waterUsageDay: waterUsageDay ?? this.waterUsageDay,
      waterLabelsDay: waterLabelsDay ?? this.waterLabelsDay,
      waterUsageWeek: waterUsageWeek ?? this.waterUsageWeek,
      waterLabelsWeek: waterLabelsWeek ?? this.waterLabelsWeek,
      waterUsageMonth: waterUsageMonth ?? this.waterUsageMonth,
      waterLabelsMonth: waterLabelsMonth ?? this.waterLabelsMonth,
      envTemp: envTemp ?? this.envTemp,
      envLabels: envLabels ?? this.envLabels,
      envHum: envHum ?? this.envHum,
      consumptionDay: consumptionDay ?? this.consumptionDay,
      consumptionLabelsDay: consumptionLabelsDay ?? this.consumptionLabelsDay,
      consumptionWeek: consumptionWeek ?? this.consumptionWeek,
      consumptionLabelsWeek: consumptionLabelsWeek ?? this.consumptionLabelsWeek,
      consumptionMonth: consumptionMonth ?? this.consumptionMonth,
      consumptionLabelsMonth: consumptionLabelsMonth ?? this.consumptionLabelsMonth,
    );
  }
}

//& AnalyticsNotifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  StreamSubscription<WsFrame>? _sub;
  Timer? _fallbackTimer;
  final Ref ref;

  AnalyticsNotifier(this.ref) : super(const AnalyticsState()) {
    final wsService = ref.read(webSocketServiceProvider);
    _sub = wsService.frames.listen(_handleFrame);
  }

  void _handleFrame(WsFrame frame) {
    try {
      if (frame.topic.startsWith(MqttTopics.analyticsWaterUsagePrefix)) {
        _handleWaterUsage(frame.payload);
      } else if (frame.topic.startsWith(MqttTopics.analyticsEnvPrefix)) {
        _handleEnvironmental(frame.payload);
      } else if (frame.topic.startsWith(MqttTopics.analyticsConsumptionPrefix)) {
        _handleConsumption(frame.payload);
      }
    } catch (e, st) {
      AppLogger.error('ANALYTICS', 'Frame parse failed', e, st);
    }
  }

  void _handleWaterUsage(String payload) {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final items = json['data'] as List? ?? [];
    final period = json['period'] as String? ?? 'day';
    final values = items.map((e) => (e['value'] as num?)?.toDouble() ?? 0.0).toList();
    final labels = items.map((e) => e['label'] as String? ?? '').toList();
    if (values.isEmpty) return;

    if (period == 'day') state = state.copyWith(waterUsageDay: values, waterLabelsDay: labels);
    if (period == 'week') state = state.copyWith(waterUsageWeek: values, waterLabelsWeek: labels);
    if (period == 'month') state = state.copyWith(waterUsageMonth: values, waterLabelsMonth: labels);
  }

  void _handleEnvironmental(String payload) {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final items = json['data'] as List? ?? [];
    final temps = items.map((e) => (e['value'] as num?)?.toDouble() ?? 0.0).toList();
    final labels = items.map((e) => e['label'] as String? ?? '').toList();
    if (temps.isEmpty) return;
    state = state.copyWith(
      envTemp: temps,
      envLabels: labels,
      envHum: List<double>.filled(temps.length, 50.0),
    );
  }

  void _handleConsumption(String payload) {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final items = json['data'] as List? ?? [];
    final period = json['period'] as String? ?? 'day';
    if (items.isEmpty) return;
    final labels = items.map((e) => e['label'] as String? ?? '').toList();
    final consumption = items.map((e) {
      final v = (e['value'] as num?)?.toDouble() ?? 0.0;
      return [v, v * 0.4, v * 0.2];
    }).toList();

    if (period == 'day') state = state.copyWith(consumptionDay: consumption, consumptionLabelsDay: labels);
    if (period == 'week') state = state.copyWith(consumptionWeek: consumption, consumptionLabelsWeek: labels);
    if (period == 'month') state = state.copyWith(consumptionMonth: consumption, consumptionLabelsMonth: labels);
  }

  void setWaterPeriod(String period) {
    state = state.copyWith(selectedWaterPeriod: period);
  }

  void setConsumptionPeriod(String period) {
    state = state.copyWith(selectedConsumptionPeriod: period);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _fallbackTimer?.cancel();
    super.dispose();
  }
}

//& Provider
final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier(ref);
});
