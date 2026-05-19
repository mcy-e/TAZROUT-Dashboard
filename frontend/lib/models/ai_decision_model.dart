//? Data model for a single AI decision log entry.
//? Matches AiDecision entity in BACKEND_DATA_REQUIREMENTS.md.
//? Deserialized from tazrout/ai/decisions and tazrout/ai/decisions/latest frames.

//& Imports
import 'dart:ui';
import '../core/theme/app_colors.dart';

//& Decision Type Enum
enum DecisionType { irrigation, alert, advice, critical }

//& AI Decision Model
class AiDecisionModel {
  final String decisionId;
  final DateTime decisionDate;
  final DecisionType type;
  final List<String> affectedZones;
  final String description;
  final String notes;
  final String farmerAdvice;

  //* Const constructor for AiDecisionModel
  const AiDecisionModel({
    required this.decisionId,
    required this.decisionDate,
    required this.type,
    required this.affectedZones,
    required this.description,
    required this.notes,
    required this.farmerAdvice,
  });

  //* Deserializes from backend AI_DECISION packet JSON
  factory AiDecisionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['decision_type'] as String?)?.toUpperCase() ?? 'ADVICE';
    final type = switch (typeStr) {
      'IRRIGATION' => DecisionType.irrigation,
      'ALERT' => DecisionType.alert,
      'CRITICAL' => DecisionType.critical,
      _ => DecisionType.advice,
    };
    final rawZones = json['affected_zones'];
    final zones = rawZones is List ? rawZones.cast<String>() : <String>[];
    return AiDecisionModel(
      decisionId: json['decision_id'] as String? ?? '',
      decisionDate: DateTime.tryParse(json['decision_date'] as String? ?? '') ?? DateTime.now(),
      type: type,
      affectedZones: zones,
      description: json['description'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      farmerAdvice: json['farmer_advice'] as String? ?? '',
    );
  }

  //* Helper to get display label per type
  String get label {
    switch (type) {
      case DecisionType.irrigation:
        return 'IRRIGATION';
      case DecisionType.alert:
        return 'ALERT';
      case DecisionType.advice:
        return 'ADVICE';
      case DecisionType.critical:
        return 'CRITICAL';
    }
  }

  //* Helper to get display color per type
  Color get color {
    switch (type) {
      case DecisionType.irrigation:
        return AppColors.primary;
      case DecisionType.alert:
        return AppColors.series3Amber;
      case DecisionType.advice:
        return AppColors.series2Blue;
      case DecisionType.critical:
        return AppColors.errorSolid;
    }
  }
}

