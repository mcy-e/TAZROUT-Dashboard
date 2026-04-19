//? Bar chart showing water usage in liters per month.
//? Period toggle: Day / Month / Year (tab-style buttons).
//? Uses fl_chart BarChart.
// TODO :: Wire to MQTT topic: tazrout/analytics/water-usage

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../widgets/common/empty_state_widget.dart';

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

  List<String> _labelsForPeriod(BuildContext context, String period) {
    final locale = Localizations.localeOf(context).toString();
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case 'Day':
        return List.generate(
          5,
          (i) => DateFormat.E(locale).format(DateTime(2024, 1, 1 + i)),
        );
      case 'Week':
        return List.generate(5, (i) => l10n.chartWeekLabel(i + 1));
      case 'Month':
        return List.generate(
          5,
          (i) => DateFormat.MMM(locale).format(DateTime(2024, i + 1, 1)),
        );
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final data = _periodData[_selectedPeriod] ?? [];
    final labels = _labelsForPeriod(context, _selectedPeriod);
    final maxY = data.isEmpty ? 10.0 : data.reduce((a, b) => a > b ? a : b) * 1.2;

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
                  l10n.waterUsageTitle,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.overlineS.copyWith(
                    color: isDark ? AppColors.darkSubtleText : AppColors.lightMutedText,
                  ),
                ),
                const Spacer(),
                _PeriodToggle(
                  selectedPeriod: _selectedPeriod,
                  l10n: l10n,
                  onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //* Bar Chart area
            Expanded(
              child: data.isEmpty
                  ? EmptyStateWidget(message: l10n.emptyStateNoData)
                  : BarChart(
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
                                l10n.waterUsageTooltipLiters(rod.toY.round().toString()),
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
                                      textDirection: textDirectionForUiLocale(context),
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
  final AppLocalizations l10n;
  final ValueChanged<String> onPeriodChanged;

  const _PeriodToggle({
    required this.selectedPeriod,
    required this.l10n,
    required this.onPeriodChanged,
  });

  String _labelForPeriod(String period) {
    return switch (period) {
      'Day' => l10n.chartPeriodDay,
      'Week' => l10n.chartPeriodWeek,
      'Month' => l10n.chartPeriodMonth,
      _ => period,
    };
  }

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
              _labelForPeriod(period),
              textDirection: textDirectionForUiLocale(context),
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
