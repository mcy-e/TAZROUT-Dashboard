//? Three sensor readings displayed as a compact column on the right.
//? Labels: T : C° / M : g/m³ / Water : %

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ZoneStatsRow Widget
class ZoneStatsRow extends StatelessWidget {
  final double temperature;
  final double moisture;
  final double waterLevel;
  final bool isOnline;

  //* StatelessWidget — receives sensor readings and online status
  const ZoneStatsRow({
    super.key,
    required this.temperature,
    required this.moisture,
    required this.waterLevel,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Column of 3 Rows
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildStatRow(
          'T : C°',
          isOnline ? '${temperature.toStringAsFixed(0)}°C' : '-',
          context,
          isDark,
        ),
        const SizedBox(height: 4),
        _buildStatRow(
          'M : g/m³',
          isOnline ? moisture.toStringAsFixed(0) : '-',
          context,
          isDark,
        ),
        const SizedBox(height: 4),
        _buildStatRow(
          'Water : %',
          isOnline ? '${(waterLevel * 100).toStringAsFixed(0)}%' : '-',
          context,
          isDark,
        ),
      ],
    );
  }

  //* Build a single stat row with label and value
  Widget _buildStatRow(String label, String value, BuildContext context, bool isDark) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          //* Text(label) AppTypography.captionMedium muted — fixed width 60px
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTypography.captionMedium.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
          ),
          const Spacer(),
          //* Text(value) AppTypography.bodySBold
          Text(
            value,
            style: AppTypography.bodySBold.copyWith(
              color: isOnline
                  ? (isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText)
                  : AppColors.darkMutedText,
            ),
          ),
        ],
      ),
    );
  }
}
