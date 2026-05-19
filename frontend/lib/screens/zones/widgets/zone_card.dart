//? Individual zone card — collapsed shows symbol + Show stats button.
//? Expanded shows device state badge, sensor stats, valve bar.
//? Online cards: green top border accent (3px).
//? Offline cards: red top border accent (3px).
//? isExpanded state managed internally with StatefulWidget.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../models/zone_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'zone_device_badge.dart';
import 'zone_stats_row.dart';
import 'zone_valve_bar.dart';

//& Global state for tracking which zones are expanded
final zoneExpandedProvider = StateProvider.family<bool, String>((ref, zoneId) => false);

//& ZoneCard Widget
class ZoneCard extends ConsumerStatefulWidget {
  final ZoneModel zone;

  //* StatefulWidget — manages its own expanded state
  const ZoneCard({
    super.key,
    required this.zone,
  });

  @override
  ConsumerState<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends ConsumerState<ZoneCard> {

  bool _isHovered = false;
  bool _showStatsHovered = false;
  bool _hideStatsHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpanded = ref.watch(zoneExpandedProvider(widget.zone.zoneId));

    //* Wrap entire card in MouseRegion + InkWell for dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          final newState = !isExpanded;
          ref.read(zoneExpandedProvider(widget.zone.zoneId).notifier).state = newState;
          if (newState) {
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
                  ? (widget.zone.isOnline ? AppColors.primary : AppColors.errorSolid)
                  : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: (widget.zone.isOnline
                              ? AppColors.primary
                              : AppColors.errorSolid)
                          .withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              //* Base layout: top border + crossfading content
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //* Top border accent strip (3px)
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: widget.zone.isOnline
                          ? AppColors.primary
                          : AppColors.errorSolid,
                    ),
                  ),
                  //* Crossfade between Collapsed and Expanded
                  AnimatedCrossFade(
                    firstChild: _buildCollapsedBase(isDark),
                    secondChild: _buildExpandedBase(isDark),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),



              //* Floating symbol — only visible in collapsed state
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    opacity: isExpanded ? 0.0 : 1.0,
                    child: _buildFloatingSymbol(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* Collapsed State Layout
  Widget _buildCollapsedBase(bool isDark) {
    final isOnline = widget.zone.isOnline;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* Zone name text
          Text(
            widget.zone.zoneName,
            style: AppTypography.headingS.copyWith(
              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
            ),
          ),
          const SizedBox(height: 16),
          //* Placeholder matching the floating symbol height
          const SizedBox(height: 88),
          const SizedBox(height: 16),
          //* Show stats button with pattern overlay on hover
          MouseRegion(
            onEnter: (_) => setState(() => _showStatsHovered = true),
            onExit: (_) => setState(() => _showStatsHovered = false),
            child: Stack(
              children: [
                //* Pattern overlay gently zooms and fades in to match button dimensions exactly
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    opacity: _showStatsHovered ? 1.0 : 0.0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      scale: _showStatsHovered ? 1.0 : 0.85,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: IgnorePointer(
                          child: SvgPicture.asset(
                            isDark
                                ? (isOnline ? AppAssets.showStatsNavActiveDark : AppAssets.showStatsNavInactiveDark)
                                : (isOnline ? AppAssets.showStatsNavActiveLight : AppAssets.showStatsNavInactiveLight),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //* The OutlineButton is layered on top so text remains crisp and clickable
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => ref.read(zoneExpandedProvider(widget.zone.zoneId).notifier).state = true,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isOnline ? AppColors.primary : AppColors.errorSolid,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: isOnline ? AppColors.primary : AppColors.errorSolid,
                      overlayColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
                      backgroundColor: _showStatsHovered
                          ? (isOnline
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : AppColors.errorSolid.withValues(alpha: 0.06))
                          : AppColors.lightSurfaceCard.withValues(alpha: 0.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.showStats,
                      style: AppTypography.bodySMedium.copyWith(
                        color: isOnline ? AppColors.primary : AppColors.errorSolid,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //* Expanded State Layout
  Widget _buildExpandedBase(bool isDark) {
    final isOnline = widget.zone.isOnline;
    final color = isOnline ? AppColors.primary : AppColors.errorSolid;
    //* Use default symbol asset for the inline expanded header decoration
    final inlineSymbol = isOnline
        ? AppAssets.symbolFertilityDefault
        : AppAssets.symbolEnFertilityDefault;

    return Column(
      children: [
        //* Header Row: zone name + inline aligned symbol + hide stats button
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //* Zone name
              Text(
                widget.zone.zoneName,
                style: AppTypography.headingS.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
              const SizedBox(width: 8),
              //* Small symbol inline — naturally aligned with the text baseline
              SvgPicture.asset(
                inlineSymbol,
                height: 18,
                colorFilter: ColorFilter.mode(
                  color.withValues(alpha: 0.45),
                  BlendMode.srcIn,
                ),
              ),
              const Spacer(),
              //* Hide stats button with hover pattern
              _buildHideStatsButton(isDark),
            ],
          ),
        ),
        //* Device badge + stats row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ZoneDeviceBadge(isOnline: widget.zone.isOnline),
              const Spacer(),
              ZoneStatsRow(
                temperature: widget.zone.temperature,
                moisture: widget.zone.moisture,
                waterLevel: widget.zone.waterLevel,
                isOnline: widget.zone.isOnline,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ZoneValveBar(
          isValveOpen: widget.zone.isValveOpen,
          isOnline: widget.zone.isOnline,
        ),
      ],
    );
  }

  //* Hide stats button — hover background + pattern overlay, tinted by status
  Widget _buildHideStatsButton(bool isDark) {
    final isOnline = widget.zone.isOnline;
    return MouseRegion(
      onEnter: (_) => setState(() => _hideStatsHovered = true),
      onExit: (_) => setState(() => _hideStatsHovered = false),
      child: Stack(
        children: [
          //* Pattern overlay gently zooms and fades in to match button dimensions exactly
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              opacity: _hideStatsHovered ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                scale: _hideStatsHovered ? 1.0 : 0.85,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: IgnorePointer(
                    child: SvgPicture.asset(
                      isDark
                          ? (isOnline ? AppAssets.showStatsNavActiveDark : AppAssets.showStatsNavInactiveDark)
                          : (isOnline ? AppAssets.showStatsNavActiveLight : AppAssets.showStatsNavInactiveLight),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //* Button on top
          OutlinedButton(
            onPressed: () => ref.read(zoneExpandedProvider(widget.zone.zoneId).notifier).state = false,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isOnline ? AppColors.primary : AppColors.errorSolid,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              foregroundColor: isOnline ? AppColors.primary : AppColors.errorSolid,
              overlayColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
              backgroundColor: _hideStatsHovered
                  ? (isOnline
                      ? AppColors.primary.withValues(alpha: 0.06)
                      : AppColors.errorSolid.withValues(alpha: 0.06))
                  : AppColors.lightSurfaceCard.withValues(alpha: 0.0),
            ),
            child: Text(
              AppLocalizations.of(context)!.hideStats,
              style: AppTypography.overlineS.copyWith(
                color: isOnline ? AppColors.primary : AppColors.errorSolid,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //* Floating symbol — centered in collapsed card, fades out when expanding
  Widget _buildFloatingSymbol() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 84),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: 56,
          child: _buildAnimatedSymbol(),
        ),
      ),
    );
  }

  Widget _buildAnimatedSymbol() {
    final color = widget.zone.isOnline ? AppColors.primary : AppColors.errorSolid;
    final defaultAsset = widget.zone.isOnline
        ? AppAssets.symbolFertilityDefault
        : AppAssets.symbolEnFertilityDefault;
    final hoverAsset = widget.zone.isOnline
        ? AppAssets.symbolFertilityHover
        : AppAssets.symbolEnFertilityHover;

    return AnimatedRotation(
      //* Offline symbols revolve smoothly half a turn when hovered
      turns: (_isHovered && !widget.zone.isOnline) ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedCrossFade(
        firstChild: SvgPicture.asset(
          defaultAsset,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        secondChild: SvgPicture.asset(
          hoverAsset,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        crossFadeState: _isHovered
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}
