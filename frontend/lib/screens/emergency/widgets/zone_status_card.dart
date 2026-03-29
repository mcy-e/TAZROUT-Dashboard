//? Minimal zone card for emergency monitoring.
//? Shows zone name + ONLINE/OFFLINE badge only.
//? No expand/collapse — this screen is read-only status monitoring.
//? Online hover: subtle green shimmer (AppColors.primary10 bg).
//? Offline hover: subtle red shimmer (AppColors.error10 bg).
//? Offline card: red border accent top (3px AppColors.errorSolid).
//? Online card: no top border accent (clean).

//& Imports
import 'package:flutter/material.dart';
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

    //* MouseRegion + InkWell for dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {}, //* Read-only status monitoring
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isOnline ? AppColors.primary10 : AppColors.error10)
                : (isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              //* Offline card: red border accent top (3px AppColors.errorSolid)
              if (!widget.isOnline)
                Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.errorSolid,
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //* Text(zoneName) AppTypography.headingS
                    Text(
                      widget.zoneName,
                      style: AppTypography.headingS.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    //* _StatusBadge(isOnline)
                    _StatusBadge(isOnline: widget.isOnline),
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
    //* Container pill shape, padding horizontal 12 vertical 4
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        //* Badge bg: Online: AppColors.primary10, Offline: AppColors.error10
        color: isOnline ? AppColors.primary10 : AppColors.error10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Container 8px circle: Online: AppColors.primary, Offline: AppColors.errorSolid
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.primary : AppColors.errorSolid,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          //* Text(isOnline ? "ONLINE" : "OFFLINE") AppTypography.overlineXS
          Text(
            isOnline ? 'ONLINE' : 'OFFLINE',
            style: AppTypography.overlineXS.copyWith(
              color: isOnline ? AppColors.primary : AppColors.errorSolid,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
