//? Line chart showing temperature and humidity trends.
//? Two-line chart: Temp (red) + Humidity (blue).
//? Shows current average temp as large KPI number.
// TODO :: Wire to MQTT topic: tazrout/analytics/environmental-stats

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& EnvStatsCard Widget
class EnvStatsCard extends StatelessWidget {
  //* StatelessWidget — displays environmental statistics line chart
  const EnvStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Header Row: Title + Legend
            Row(
              children: [
                Text(
                  'ENV STATS',
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
                    Text('Temp', style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10)),
                    const SizedBox(width: 8),
                    _buildLegendDot(AppColors.series2Blue),
                    const SizedBox(width: 4),
                    Text('Hum', style: AppTypography.captionMedium.copyWith(color: AppColors.darkMutedText, fontSize: 10)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            //* Large KPI number
            Text(
              '24°C',
              style: AppTypography.displayL.copyWith(
                color: AppColors.primary,
                fontSize: 32,
              ),
            ),
            Text(
              'AVG TEMP',
              style: AppTypography.overlineXS.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 8),
            //* Line Chart area
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    //* Temp Line: AppColors.errorSolid
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 22),
                        FlSpot(1, 23),
                        FlSpot(2, 24),
                        FlSpot(3, 22),
                        FlSpot(4, 25),
                        FlSpot(5, 24),
                        FlSpot(6, 23),
                        FlSpot(7, 24),
                      ],
                      isCurved: true,
                      color: AppColors.errorSolid,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                    //* Humidity Line: AppColors.series2Blue
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 45),
                        FlSpot(1, 48),
                        FlSpot(2, 44),
                        FlSpot(3, 46),
                        FlSpot(4, 42),
                        FlSpot(5, 45),
                        FlSpot(6, 47),
                        FlSpot(7, 45),
                      ],
                      isCurved: true,
                      color: AppColors.series2Blue,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  minX: 0,
                  maxX: 7,
                  minY: 20,
                  maxY: 50,
                ),
              ),
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
