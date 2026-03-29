//? Individual zone zone card — collapsed shows logo + Show stats button.
//? Expanded shows device state badge, sensor stats, valve bar.
//? Online cards: green top border accent (3px).
//? Offline cards: red top border accent (3px).
//? isExpanded state managed internally with StatefulWidget.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../models/zone_model.dart';
import 'zone_device_badge.dart';
import 'zone_stats_row.dart';
import 'zone_valve_bar.dart';

//& ZoneCard Widget
class ZoneCard extends StatefulWidget {
  final ZoneModel zone;

  //* StatefulWidget — manages its own expanded state
  const ZoneCard({
    super.key,
    required this.zone,
  });

  @override
  State<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends State<ZoneCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Wrap entire card in MouseRegion + InkWell for dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          setState(() => _isExpanded = !_isExpanded);
          if (_isExpanded) {
            AppLogger.nav('ZONES', 'Expanded zone ${widget.zone.zoneId}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Top border accent strip (3px)
              Container(
                height: 3,
                width: double.infinity,
                color: widget.zone.isOnline ? AppColors.primary : AppColors.errorSolid,
              ),
              //* Content based on state
              if (!_isExpanded) _buildCollapsed(isDark) else _buildExpanded(isDark),
            ],
          ),
        ),
      ),
    );
  }

  //* Collapsed State Layout
  Widget _buildCollapsed(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* Text(zoneName) AppTypography.headingS
          Text(
            widget.zone.zoneName,
            style: AppTypography.headingS.copyWith(
              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          const SizedBox(height: 16),
          //* SvgPicture.asset(AppAssets.symbolWisdom)
          SvgPicture.asset(
            AppAssets.symbolWisdom,
            height: 64,
            colorFilter: ColorFilter.mode(
              isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          //* Show stats OutlinedButton full width
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                setState(() => _isExpanded = true);
                AppLogger.nav('ZONES', 'Expanded zone ${widget.zone.zoneId}');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'SHOW STATS',
                style: AppTypography.bodySMedium.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //* Expanded State Layout
  Widget _buildExpanded(bool isDark) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //* Row: Text(zoneName) | Spacer() | Hide stats button
              Row(
                children: [
                  Text(
                    widget.zone.zoneName,
                    style: AppTypography.headingS.copyWith(
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  const Spacer(),
                  //* Hide stats OutlinedButton small
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isExpanded = false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: widget.zone.isOnline ? AppColors.primary : AppColors.errorSolid,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        'HIDE',
                        style: AppTypography.overlineXS.copyWith(
                          color: widget.zone.isOnline ? AppColors.primary : AppColors.errorSolid,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              //* Row: Badge | Stats
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Left: ZoneDeviceBadge(isOnline)
                  ZoneDeviceBadge(isOnline: widget.zone.isOnline),
                  const Spacer(),
                  //* Right: ZoneStatsRow(temperature, moisture, waterLevel)
                  ZoneStatsRow(
                    temperature: widget.zone.temperature,
                    moisture: widget.zone.moisture,
                    waterLevel: widget.zone.waterLevel,
                    isOnline: widget.zone.isOnline,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        //* ZoneValveBar(isValveOpen, isOnline)
        ZoneValveBar(
          isValveOpen: widget.zone.isValveOpen,
          isOnline: widget.zone.isOnline,
        ),
      ],
    );
  }
}
