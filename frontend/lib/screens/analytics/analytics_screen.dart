//? Analytics screen — composes all analytics widgets.
//? No widget implementation here — layout only.
// TODO :: Wire real-time AI decisions via MQTT: tazrout/ai/decisions

//& Imports
import 'package:flutter/material.dart';
import 'widgets/ai_latest_decision_card.dart';
import 'widgets/observation_card.dart';
import 'widgets/recommendation_card.dart';
import 'widgets/water_usage_card.dart';
import 'widgets/decision_logs_card.dart';
import 'widgets/env_stats_card.dart';
import 'widgets/resource_consumption_card.dart';

//& AnalyticsScreen Widget
class AnalyticsScreen extends StatelessWidget {
  //* StatelessWidget — composes the analytics dashboard layout
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* LayoutBuilder for explicit height constraints
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Left Column (flex 2)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      //* AiLatestDecisionCard (fixed height ~220px)
                      const SizedBox(
                        height: 220,
                        child: AiLatestDecisionCard(),
                      ),
                      const SizedBox(height: 16),
                      //* Row of Observation + Recommendation
                      const SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(child: ObservationCard()),
                            SizedBox(width: 16),
                            Expanded(child: RecommendationCard()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      //* WaterUsageCard (takes remaining height)
                      const Expanded(
                        child: WaterUsageCard(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                //* Right Column (flex 3)
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      //* DecisionLogsCard (fixed height ~320px)
                      const SizedBox(
                        height: 320,
                        child: DecisionLogsCard(),
                      ),
                      const SizedBox(height: 16),
                      //* Row of EnvStats + ResourceConsumption
                      //* (both take remaining height equally)
                      const Expanded(
                        child: Row(
                          children: [
                            Expanded(child: EnvStatsCard()),
                            SizedBox(width: 16),
                            Expanded(child: ResourceConsumptionCard()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
