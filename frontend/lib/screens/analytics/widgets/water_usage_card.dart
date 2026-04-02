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
class WaterUsageCard extends StatefulWidget {
  const WaterUsageCard({super.key});

  @override
  State<WaterUsageCard> createState() => _WaterUsageCardState();
}

class _WaterUsageCardState extends State<WaterUsageCard> {
  String _selectedPeriod = 'Month';

  static const Map<String, List<double>> _periodData = {
    'Day': [20, 35, 28, 42, 38],
    'Week': [120, 180, 150, 200, 170],
    'Month': [480, 620, 550, 410, 700],
  };

  static const Map<String, List<String>> _periodLabels = {
    'Day': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    'Week': ['W1', 'W2', 'W3', 'W4', 'W5'],
    'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = _periodData[_selectedPeriod]!;
    final labels = _periodLabels[_selectedPeriod]!;
    final maxY = data.reduce((a, b) => a > b ? a : b) * 1.2;

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
                _PeriodToggle(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //* Bar Chart area
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
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
                          final index = value.toInt();
                          if (index >= 0 && index < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                labels[index],
                                style: AppTypography.overlineXS.copyWith(
                                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
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
                    //* Period-driven static data (5 bars per period)
                    // TODO :: Replace with real MQTT data from topic: tazrout/analytics/water-usage
                    for (int i = 0; i < data.length; i++) _buildBarGroup(i, data[i]),
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
class _PeriodToggle extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const _PeriodToggle({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleButton(context, isDark, 'Day'),
        const SizedBox(width: 4),
        _buildToggleButton(context, isDark, 'Week'),
        const SizedBox(width: 4),
        _buildToggleButton(context, isDark, 'Month'),
      ],
    );
  }

  Widget _buildToggleButton(BuildContext context, bool isDark, String period) {
    final isSelected = selectedPeriod == period;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          onPeriodChanged(period);
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 32),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              period,
              style: AppTypography.captionMedium.copyWith(
                color: isSelected
                    ? (isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
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
