//? Stacked bar chart showing Water/Moisture/Temp per zone.
//? Period toggle: Day / Week / Month.
//? Legend: Water (blue) / Moisture (green) / Temp (red).
// TODO :: Wire to MQTT topic: tazrout/analytics/consumption-by-zone

//& Imports
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../../widgets/common/empty_state_widget.dart';
import '../../../../providers/analytics_provider.dart';
import '../../../../providers/zone_provider.dart';

//& ResourceConsumptionCard Widget
class ResourceConsumptionCard extends ConsumerStatefulWidget {
  //* StatefulWidget — stacked bar chart + working period toggle
  const ResourceConsumptionCard({super.key});

  @override
  ConsumerState<ResourceConsumptionCard> createState() => _ResourceConsumptionCardState();
}

class _ResourceConsumptionCardState extends ConsumerState<ResourceConsumptionCard> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final analyticsState = ref.watch(analyticsProvider);
    final zones = ref.watch(zonesProvider);
    final allZoneData = analyticsState.currentConsumption;
    final allLabels = analyticsState.currentConsumptionLabels;

    // Preview: first 3 zones only
    final previewData = allZoneData.take(3).toList();
    final previewLabels = allLabels.take(3).toList();
    final previewZones = zones.take(3).toList();

    final maxY = previewData.isEmpty
        ? 10.0
        : previewData
            .map((zone) => zone[0] + zone[1] + zone[2])
            .reduce((a, b) => a > b ? a : b) *
            1.2;

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
            //* Header Row: Title + Period Toggle + See All
            Row(
              children: isArabic(context)
                  ? [
                      TextButton(
                        onPressed: () => _showAllZonesDialog(context, isDark, l10n, allZoneData, allLabels),
                        child: Text(l10n.viewAll, style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      ),
                      _PeriodToggle(
                        selectedPeriod: _selectedPeriod,
                        l10n: l10n,
                        onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.resourceConsumptionTitle,
                          textAlign: TextAlign.right,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.headingXS.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ]
                  : [
                      Flexible(
                        child: Text(
                          l10n.resourceConsumptionTitle,
                          textAlign: TextAlign.left,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.headingXS.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _PeriodToggle(
                        selectedPeriod: _selectedPeriod,
                        l10n: l10n,
                        onPeriodChanged: (period) {
                          setState(() => _selectedPeriod = period);
                          ref.read(analyticsProvider.notifier).setConsumptionPeriod(period.toLowerCase());
                        },
                      ),
                      TextButton(
                        onPressed: () => _showAllZonesDialog(context, isDark, l10n, allZoneData, allLabels),
                        child: Text(l10n.viewAll, style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      ),
                    ],
            ),
            const SizedBox(height: 16),
            //* Stacked Bar Chart — first 3 zones only
            Expanded(
              child: previewData.isEmpty
                  ? EmptyStateWidget(message: l10n.emptyStateNoData)
                  : GestureDetector(
                      onTap: () => _showAllZonesDialog(context, isDark, l10n, allZoneData, allLabels),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final name = groupIndex < previewZones.length ? previewZones[groupIndex].zoneName : 'Zone ${groupIndex + 1}';
                                return BarTooltipItem(
                                  '$name\n${rod.toY.toStringAsFixed(1)} L',
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
                                  if (index >= 0 && index < previewZones.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        previewLabels[index],
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
                            for (int x = 0; x < previewData.length; x++)
                              _buildStackedBar(x, previewData[x][0], previewData[x][1], previewData[x][2]),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            //* Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(context, AppColors.series2Blue, l10n.legendWaterShort),
                const SizedBox(width: 16),
                _buildLegendItem(context, AppColors.primary, l10n.legendMoistureShort),
                const SizedBox(width: 16),
                _buildLegendItem(context, AppColors.errorSolid, l10n.legendTempShort),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAllZonesDialog(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    List<List<double>> allData,
    List<String> zoneNames,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.resourceConsumptionTitle, style: AppTypography.headingS),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: allData.isEmpty
                    ? EmptyStateWidget(message: l10n.emptyStateNoData)
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: allData
                              .map((z) => z[0] + z[1] + z[2])
                              .reduce((a, b) => a > b ? a : b) * 1.2,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final name = groupIndex < zoneNames.length ? zoneNames[groupIndex] : 'Zone ${groupIndex + 1}';
                                return BarTooltipItem(
                                  '$name\n${rod.toY.toStringAsFixed(1)} L',
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
                                  if (index >= 0 && index < zoneNames.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        zoneNames[index],
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
                            for (int x = 0; x < allData.length; x++)
                              _buildStackedBar(x, allData[x][0], allData[x][1], allData[x][2]),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context, AppColors.series2Blue, l10n.legendWaterShort),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, AppColors.primary, l10n.legendMoistureShort),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, AppColors.errorSolid, l10n.legendTempShort),
                ],
              ),
            ],
          ),
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

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: isArabic(context)
          ? [
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.overlineXS.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          : [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.overlineXS.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ),
            ],
    );
  }
}

//& _PeriodToggle Widget
class _PeriodToggle extends StatefulWidget {
  final String selectedPeriod;
  final AppLocalizations l10n;
  final ValueChanged<String> onPeriodChanged;

  const _PeriodToggle({
    required this.selectedPeriod,
    required this.l10n,
    required this.onPeriodChanged,
  });

  @override
  State<_PeriodToggle> createState() => _PeriodToggleState();
}

class _PeriodToggleState extends State<_PeriodToggle> {
  String _labelForPeriod(String period) {
    final l = widget.l10n;
    return switch (period) {
      'Day' => l.chartPeriodDay,
      'Week' => l.chartPeriodWeek,
      'Month' => l.chartPeriodMonth,
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
    final isSelected = widget.selectedPeriod == period;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => widget.onPeriodChanged(period),
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
                    ? (isDark
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText)
                    : (isDark
                        ? AppColors.darkMutedText
                        : AppColors.lightMutedText),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
