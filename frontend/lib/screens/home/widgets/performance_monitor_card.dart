//? Large card containing 2x2 grid of MetricSubCard widgets.
//? Header: green pulse icon + "Performance Monitor" title + 3 dots.
// TODO :: Wire to MQTT topic: tazrout/dashboard/performance
// TODO :: Wire live values to MQTT SENSOR_UPDATE events
// TODO :: Wire to Spring Boot WebSocket via web_socket_channel

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../widgets/common/empty_state_widget.dart';

//& PerformanceMonitorCard
class PerformanceMonitorCard extends StatelessWidget {
  //* Outer Card, padding 16px
  const PerformanceMonitorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // TODO :: Wire to MQTT topic: tazrout/dashboard/performance
    final Map<String, String> data = {
      'water': '42%',
      'soil': '620 g/kg',
      'temp': '24°C',
      'humidity': '45%',
    };

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
              children: isArabic(context)
                  ? [
                      Row(
                        children: [
                          _buildDot(AppColors.primary),
                          const SizedBox(width: 4),
                          _buildDot(AppColors.darkStrokeDivider),
                          const SizedBox(width: 4),
                          _buildDot(AppColors.darkStrokeDivider),
                        ],
                      ),
                      const Spacer(),
                      //* Title
                      Text(
                        l10n.performanceMonitor,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingXS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      //* Icon: green pulse/activity icon
                      SvgPicture.asset(
                        isDark ? AppAssets.darkIconPerformance : AppAssets.lightIconPerformance,
                        height: 18,
                      ),
                    ]
                  : [
                      //* Icon: green pulse/activity icon
                      SvgPicture.asset(
                        isDark ? AppAssets.darkIconPerformance : AppAssets.lightIconPerformance,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      //* Title
                      Text(
                        l10n.performanceMonitor,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
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
            //* Content Area
            Expanded(
              child: data.isEmpty
                  ? EmptyStateWidget(message: l10n.emptyStateNoData)
                  : Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              //* 1. Water Output
                              Expanded(
                                child: _MetricSubCard(
                                  label: l10n.waterOutput,
                                  value: data['water'] ?? '',
                                  accentColor: AppColors.primary,
                                  darkIcon: AppAssets.darkIconWaterI,
                                  lightIcon: AppAssets.lightIconWaterI,
                                  hoverDarkIcon: AppAssets.darkIconWaterH,
                                  hoverLightIcon: AppAssets.lightIconWaterH,
                                  chartColor: AppColors.series1Primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              //* 2. Soil Moisture
                              Expanded(
                                child: _MetricSubCard(
                                  label: l10n.soilMoisture,
                                  value: data['soil'] ?? '',
                                  accentColor: AppColors.series2Blue,
                                  darkIcon: AppAssets.darkIconSoilIdle,
                                  lightIcon: AppAssets.lightIconSoilIdle,
                                  hoverDarkIcon: AppAssets.darkIconSoilH,
                                  hoverLightIcon: AppAssets.lightIconSoilH,
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
                                  label: l10n.temperature,
                                  value: data['temp'] ?? '',
                                  accentColor: AppColors.errorSolid,
                                  darkIcon: AppAssets.darkIconTemperatureI,
                                  lightIcon: AppAssets.lightIconTemperatureI,
                                  hoverDarkIcon: AppAssets.darkIconTemperatureH,
                                  hoverLightIcon: AppAssets.lightIconTemperatureH,
                                  chartColor: AppColors.errorSolid,
                                ),
                              ),
                              const SizedBox(width: 12),
                              //* 4. Humidity
                              Expanded(
                                child: _MetricSubCard(
                                  label: l10n.humidity,
                                  value: data['humidity'] ?? '',
                                  accentColor: AppColors.series3Amber,
                                  darkIcon: AppAssets.darkIconHumidityI,
                                  lightIcon: AppAssets.lightIconHumidityI,
                                  hoverDarkIcon: AppAssets.darkIconHumidityH,
                                  hoverLightIcon: AppAssets.lightIconHumidityH,
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
class _MetricSubCard extends StatefulWidget {
  final String label;
  final String value;
  final Color accentColor;
  final String darkIcon;
  final String lightIcon;
  final String hoverDarkIcon;
  final String hoverLightIcon;
  final Color chartColor;

  const _MetricSubCard({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.darkIcon,
    required this.lightIcon,
    required this.hoverDarkIcon,
    required this.hoverLightIcon,
    required this.chartColor,
  });

  @override
  State<_MetricSubCard> createState() => _MetricSubCardState();
}

class _MetricSubCardState extends State<_MetricSubCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Log theme resolution
    AppLogger.theme('MetricSubCard', widget.chartColor.toString(), 'chart');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
        ),
        //* PerformanceMonitorCard metric sub-cards: if content overflows
        //* on a smaller screen, wrap in SingleChildScrollView with
        //* physics: const ClampingScrollPhysics()
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: isArabic(context)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Header: Label + Icon
              Row(
                children: isArabic(context)
                    ? [
                        //* Smooth icon transition between idle and hover state
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            firstCurve: Curves.easeInOut,
                            secondCurve: Curves.easeInOut,
                            crossFadeState: _isHovered
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: SvgPicture.asset(
                              isDark ? widget.darkIcon : widget.lightIcon,
                              height: 18,
                            ),
                            secondChild: SvgPicture.asset(
                              isDark ? widget.hoverDarkIcon : widget.hoverLightIcon,
                              height: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: AppTypography.overlineXS.copyWith(
                            color: _isHovered
                              ? AppColors.primary
                              : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                          ),
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.right,
                            textDirection: textDirectionForUiLocale(context),
                          ),
                        ),
                      ]
                    : [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: AppTypography.overlineXS.copyWith(
                            color: _isHovered
                              ? AppColors.primary
                              : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                          ),
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.left,
                            textDirection: textDirectionForUiLocale(context),
                          ),
                        ),
                        const Spacer(),
                        //* Smooth icon transition between idle and hover state
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            firstCurve: Curves.easeInOut,
                            secondCurve: Curves.easeInOut,
                            crossFadeState: _isHovered
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: SvgPicture.asset(
                              isDark ? widget.darkIcon : widget.lightIcon,
                              height: 18,
                            ),
                            secondChild: SvgPicture.asset(
                              isDark ? widget.hoverDarkIcon : widget.hoverLightIcon,
                              height: 18,
                            ),
                          ),
                        ),
                      ],
              ),
              const SizedBox(height: 4),
              //* Value
              Text(
                widget.value,
                textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
                textDirection: textDirectionForUiLocale(context),
                style: AppTypography.bodyMBold.copyWith(color: widget.accentColor),
              ),
              const SizedBox(height: 8),
              //* Chart area
              SizedBox(
                height: 60,
                //* Chart area with texture background
                child: Stack(
                  children: [
                    //* Graph background texture
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          isDark
                            ? AppAssets.graphBgDarkPng
                            : AppAssets.graphBgLightPng,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //* fl_chart on top of texture
                    Positioned.fill(
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
                              color: widget.chartColor,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: widget.chartColor.withValues(alpha: 0.15),
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
            ],
          ),
        ),
      ),
    );
  }
}
