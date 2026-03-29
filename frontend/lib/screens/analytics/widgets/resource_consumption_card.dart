//? Stacked bar chart showing Water/Moisture/Temp per zone.
//? Period toggle: Day / Week / Month.
//? Legend: Water (blue) / Moisture (green) / Temp (red).
// TODO :: Wire to MQTT topic: tazrout/analytics/consumption-by-zone

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ResourceConsumptionCard Widget
class ResourceConsumptionCard extends StatelessWidget {
  //* StatelessWidget — displays stacked bar chart for zone resource consumption
  const ResourceConsumptionCard({super.key});

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
            //* Header Row: Title + Period Toggle
            Row(
              children: [
                Text(
                  'Resource Consumption by Zone',
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const Spacer(),
                const _PeriodToggle(),
              ],
            ),
            const SizedBox(height: 16),
            //* Stacked Bar Chart
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const zones = ['Zone A', 'Zone B', 'Zone C'];
                          if (value.toInt() >= 0 && value.toInt() < zones.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                zones[value.toInt()],
                                style: AppTypography.overlineXS.copyWith(
                                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    //* 3 zones: Zone A, Zone B, Zone C
                    //* Each bar stacked: Water(blue) + Moisture(green) + Temp(red)
                    // TODO :: Replace with real MQTT data from topic: tazrout/analytics/consumption-by-zone
                    _buildStackedBar(0, 30, 40, 20),
                    _buildStackedBar(1, 25, 35, 30),
                    _buildStackedBar(2, 40, 20, 25),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            //* Row Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(AppColors.series2Blue, 'WATER'),
                const SizedBox(width: 16),
                _buildLegendItem(AppColors.primary, 'MOISTURE'),
                const SizedBox(width: 16),
                _buildLegendItem(AppColors.errorSolid, 'TEMP'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildStackedBar(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1 + y2 + y3,
          width: 28,
          borderRadius: BorderRadius.circular(4),
          rodStackItems: [
            BarChartRodStackItem(0, y1, AppColors.series2Blue),
            BarChartRodStackItem(y1, y1 + y2, AppColors.primary),
            BarChartRodStackItem(y1 + y2, y1 + y2 + y3, AppColors.errorSolid),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText),
        ),
      ],
    );
  }
}

//& _PeriodToggle Widget
class _PeriodToggle extends StatefulWidget {
  const _PeriodToggle();

  @override
  State<_PeriodToggle> createState() => _PeriodToggleState();
}

class _PeriodToggleState extends State<_PeriodToggle> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleButton('Day'),
        const SizedBox(width: 4),
        _buildToggleButton('Week'),
        const SizedBox(width: 4),
        _buildToggleButton('Month'),
      ],
    );
  }

  Widget _buildToggleButton(String period) {
    final isSelected = _selectedPeriod == period;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => setState(() => _selectedPeriod = period),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 32),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              period,
              style: AppTypography.captionMedium.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
