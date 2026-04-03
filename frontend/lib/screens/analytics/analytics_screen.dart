//? Analytics screen — composes all analytics widgets.
//? No widget implementation here — layout only.
// TODO :: Wire real-time AI decisions via MQTT: tazrout/ai/decisions

//& Imports
import 'package:flutter/material.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    //* LayoutBuilder for explicit height constraints
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              l10n.analyticsTitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.start,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.headingM.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.analyticsSubtitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.start,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.bodySRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
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
                              height: 140,
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
          ],
        ),
      ),
    );
  }
}
