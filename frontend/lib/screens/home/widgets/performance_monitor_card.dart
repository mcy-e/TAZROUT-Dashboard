//? Large card containing 2x2 grid of MetricSubCard widgets.
//? Header: green pulse icon + "Performance Monitor" title + 3 dots.
// TODO :: Wire to MQTT topic: tazrout/dashboard/performance
// TODO :: Wire live values to MQTT SENSOR_UPDATE events
// TODO :: Wire to Spring Boot WebSocket via web_socket_channel

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';

//& PerformanceMonitorCard
class PerformanceMonitorCard extends StatelessWidget {
  //* Outer Card, padding 16px
  const PerformanceMonitorCard({super.key});

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
          children: [
            //* Header Row
            Row(
              children: [
                //* Icon: green pulse/activity icon (PhosphorIcons.pulse, color AppColors.primary)
                Icon(
                  PhosphorIcons.pulse(),
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                //* Title
                Text(
                  'Performance Monitor',
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const Spacer(),
                //* Three dot indicators
                Row(
                  children: [
                    _buildDot(AppColors.darkStrokeDivider),
                    const SizedBox(width: 4),
                    _buildDot(AppColors.darkStrokeDivider),
                    const SizedBox(width: 4),
                    _buildDot(AppColors.primary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            //* Replace GridView.count with a Column of two Rows
            //* Each row is Expanded, each cell is Expanded
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        //* 1. Water Output
                        Expanded(
                          child: _MetricSubCard(
                            // TODO :: Wire to MQTT topic: tazrout/dashboard/performance
                            label: 'WATER OUTPUT',
                            // TODO :: Wire live values to MQTT SENSOR_UPDATE events
                            value: '42%',
                            accentColor: AppColors.primary,
                            icon: PhosphorIcons.drop(),
                            chartColor: AppColors.series1Primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        //* 2. Soil Moisture
                        Expanded(
                          child: _MetricSubCard(
                            // TODO :: Wire to MQTT topic: tazrout/dashboard/performance
                            label: 'SOIL MOISTURE',
                            // TODO :: Wire live values to MQTT SENSOR_UPDATE events
                            value: '620 g/kg',
                            accentColor: AppColors.series2Blue,
                            icon: PhosphorIcons.equalizer(),
                            chartColor: AppColors.series2Blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      children: [
                        //* 3. Temperature
                        Expanded(
                          child: _MetricSubCard(
                            // TODO :: Wire to MQTT topic: tazrout/dashboard/performance
                            label: 'TEMPERATURE',
                            // TODO :: Wire live values to MQTT SENSOR_UPDATE events
                            value: '24°C',
                            accentColor: AppColors.errorSolid,
                            icon: PhosphorIcons.thermometer(),
                            chartColor: AppColors.errorSolid,
                          ),
                        ),
                        const SizedBox(width: 12),
                        //* 4. Humidity
                        Expanded(
                          child: _MetricSubCard(
                            // TODO :: Wire to MQTT topic: tazrout/dashboard/performance
                            label: 'HUMIDITY',
                            // TODO :: Wire live values to MQTT SENSOR_UPDATE events
                            value: '45%',
                            accentColor: AppColors.series3Amber,
                            icon: PhosphorIcons.cloud(),
                            chartColor: AppColors.series3Amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* No pattern — clean card only
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
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

//& _MetricSubCard Widget
class _MetricSubCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final IconData icon;
  final Color chartColor;

  const _MetricSubCard({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.icon,
    required this.chartColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Log theme resolution
    AppLogger.theme('MetricSubCard', chartColor.toString(), 'chart');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard,
        borderRadius: BorderRadius.circular(8),
      ),
      //* PerformanceMonitorCard metric sub-cards: if content overflows
      //* on a smaller screen, wrap in SingleChildScrollView with
      //* physics: const ClampingScrollPhysics()
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Header: Label + Icon
            Row(
              children: [
                Text(
                  label,
                  style: AppTypography.overlineXS.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                const Spacer(),
                Icon(icon, size: 16, color: accentColor),
              ],
            ),
            const SizedBox(height: 4),
            //* Value
            Text(
              value,
              style: AppTypography.bodyMBold.copyWith(color: accentColor),
            ),
            const SizedBox(height: 8),
            //* Chart area
            SizedBox(
              height: 60,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      // TODO :: Replace static chart data with real time-series from API
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3.5),
                        FlSpot(3, 5),
                        FlSpot(4, 4),
                        FlSpot(5, 6),
                        FlSpot(6, 5),
                        FlSpot(7, 7),
                      ],
                      isCurved: true,
                      color: chartColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: chartColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
