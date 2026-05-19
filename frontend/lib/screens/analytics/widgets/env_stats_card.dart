//? Line chart showing temperature and humidity trends.
//? Two-line chart: Temp (red) + Humidity (blue).
//? Shows current average temp as large KPI number.
// TODO :: Wire to MQTT topic: tazrout/analytics/environmental-stats

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../providers/analytics_provider.dart';
import '../../../../widgets/common/empty_state_widget.dart';

//& EnvStatsCard Widget
class EnvStatsCard extends ConsumerWidget {
  //* ConsumerWidget — displays environmental statistics line chart
  const EnvStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final analyticsState = ref.watch(analyticsProvider);
    
    // Mock data mimicking history points for 7 days
    final tempData = analyticsState.envTemp;
    final humData = analyticsState.envHum;
    final bool hasData = tempData.isNotEmpty && humData.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            //* Header Row: Title + Legend
            Row(
              children: isArabic(context)
                  ? [
                      Row(
                        children: [
                          Text(
                            l10n.envLegendHumShort,
                            textAlign: TextAlign.right,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10),
                          ),
                          const SizedBox(width: 4),
                          _buildLegendDot(AppColors.series2Blue),
                          const SizedBox(width: 8),
                          Text(
                            l10n.envLegendTempShort,
                            textAlign: TextAlign.right,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10),
                          ),
                          const SizedBox(width: 4),
                          _buildLegendDot(AppColors.errorSolid),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        l10n.envStatsTitle,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.overlineS.copyWith(
                          color: isDark ? AppColors.darkSubtleText : AppColors.lightMutedText,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        l10n.envStatsTitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.overlineS.copyWith(
                          color: isDark ? AppColors.darkSubtleText : AppColors.lightMutedText,
                        ),
                      ),
                      const Spacer(),
                      //* Legend
                      Row(
                        children: [
                          _buildLegendDot(AppColors.errorSolid),
                          const SizedBox(width: 4),
                          Text(
                            l10n.envLegendTempShort,
                            textAlign: TextAlign.left,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10),
                          ),
                          const SizedBox(width: 8),
                          _buildLegendDot(AppColors.series2Blue),
                          const SizedBox(width: 4),
                          Text(
                            l10n.envLegendHumShort,
                            textAlign: TextAlign.left,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
            ),
            const SizedBox(height: 8),
            //* Large KPI number — DATA from MQTT
            Text(
              hasData
                  ? '${analyticsState.envTemp.last.toStringAsFixed(1)}°C'
                  : '--',
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.displayL.copyWith(
                color: AppColors.primary,
                fontSize: 32,
              ),
            ),
            Text(
              l10n.envAvgTempLabel,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.overlineXS.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 8),
            //* Line Chart area
            Expanded(
              child: hasData 
                ? LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        //* Temp Line: real sliding window from zonesProvider
                        LineChartBarData(
                          spots: tempData
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: AppColors.errorSolid,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                        //* Humidity Line: real sliding window
                        LineChartBarData(
                          spots: humData
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: AppColors.series2Blue,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      minX: 0,
                      maxX: (tempData.length - 1).toDouble(),
                      minY: 0,
                      maxY: [tempData.isEmpty ? 50.0 : tempData.reduce((a, b) => a > b ? a : b),
                             humData.isEmpty ? 100.0 : humData.reduce((a, b) => a > b ? a : b)]
                          .reduce((a, b) => a > b ? a : b) * 1.3,
                    ),
                  )
                : EmptyStateWidget(message: l10n.emptyStateNoData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
