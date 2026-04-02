//? Minimal zone card for emergency monitoring.
//? Shows zone name + ONLINE/OFFLINE badge only.
//? No expand/collapse — this screen is read-only status monitoring.
//? Online hover: subtle green shimmer (AppColors.primary10 bg).
//? Offline hover: subtle red shimmer (AppColors.error10 bg).
//? Offline card: red border accent top (3px AppColors.errorSolid).
//? Online card: no top border accent (clean).

//& Imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ZoneStatusCard Widget
class ZoneStatusCard extends StatefulWidget {
  final String zoneName;
  final bool isOnline;

  //* ZoneStatusCard Parameters
  const ZoneStatusCard({
    super.key,
    required this.zoneName,
    required this.isOnline,
  });

  @override
  State<ZoneStatusCard> createState() => _ZoneStatusCardState();
}

class _ZoneStatusCardState extends State<ZoneStatusCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOnline = widget.isOnline;
    final statusColor = isOnline ? AppColors.primary : AppColors.errorSolid;
    final strokeDivider =
        isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider;

    //* MouseRegion + InkWell for dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {}, //* Read-only status monitoring
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              //* Card background
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? statusColor.withValues(alpha: 0.08)
                      : (isDark
                          ? AppColors.darkPanelCard
                          : AppColors.lightSurfaceCard),
                  border: Border(
                    top: BorderSide(
                      color: statusColor,
                      width: 3,
                    ),
                    left: BorderSide(color: strokeDivider),
                    right: BorderSide(color: strokeDivider),
                    bottom: BorderSide(color: strokeDivider),
                  ),
                ),
              ),
              //* Hover symbol behind content (peeks from bottom)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: -60, end: _isHovered ? -20 : -60),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (context, offset, child) {
                  return Positioned(
                    bottom: offset,
                    left: 0,
                    right: 0,
                    child: child!,
                  );
                },
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
                    child: SvgPicture.asset(
                      AppAssets.symbolBalance,
                      height: 80,
                      colorFilter: ColorFilter.mode(
                        statusColor.withValues(alpha: 0.20),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              //* Content Column (always on top)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //* Text(zoneName) AppTypography.headingS
                    Text(
                      widget.zoneName,
                      style: AppTypography.headingS.copyWith(
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    //* _StatusBadge(isOnline)
                    _StatusBadge(isOnline: isOnline),
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

//& _StatusBadge (private, same file)
class _StatusBadge extends StatelessWidget {
  final bool isOnline;

  const _StatusBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final statusColor = isOnline ? AppColors.primary : AppColors.errorSolid;
    final statusText = isOnline ? 'ONLINE' : 'OFFLINE';

    //* Container pill shape, padding horizontal 12 vertical 4
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        //* Badge bg: Online/Offline status color at low opacity
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Container 8px circle: Online/Offline dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          //* Text("ONLINE"|"OFFLINE") AppTypography.overlineXS
          Text(
            statusText,
            style: AppTypography.overlineXS.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
