//? Bar chart showing water usage in liters per month.
//? Period toggle: Day / Month / Year (tab-style buttons).
//? Uses fl_chart BarChart.
// TODO :: Wire to MQTT topic: tazrout/analytics/water-usage

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& WaterUsageCard Widget
class WaterUsageCard extends StatelessWidget {
  //* StatelessWidget — displays water usage bar chart with period toggle
  const WaterUsageCard({super.key});

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
                  'WATER USAGE (LITERS)',
                  style: AppTypography.overlineS.copyWith(
                    color: isDark ? AppColors.darkSubtleText : AppColors.lightMutedText,
                  ),
                ),
                const Spacer(),
                const _PeriodToggle(),
              ],
            ),
            const SizedBox(height: 16),
            //* Bar Chart area
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 700,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard,
                      tooltipRoundedRadius: 4,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} L',
                          AppTypography.captionMedium.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                months[value.toInt()],
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
                    //* Static data 5 bars: Jan=280 Feb=400 Mar=520 Apr=350 May=600
                    // TODO :: Replace with real MQTT data from topic: tazrout/analytics/water-usage
                    _buildBarGroup(0, 280),
                    _buildBarGroup(1, 400),
                    _buildBarGroup(2, 520),
                    _buildBarGroup(3, 350),
                    _buildBarGroup(4, 600),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.series2Blue,
          width: 28,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
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
  String _selectedPeriod = 'Month';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleButton('Day'),
        const SizedBox(width: 4),
        _buildToggleButton('Month'),
        const SizedBox(width: 4),
        _buildToggleButton('Year'),
      ],
    );
  }

  Widget _buildToggleButton(String period) {
    final isSelected = _selectedPeriod == period;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          setState(() => _selectedPeriod = period);
          // TODO :: Emit period change to trigger MQTT re-fetch
        },
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
