//? Small badge showing DEVICE STATE label + wifi icon + status text.
//? Online: green wifi icon + "Online" in AppColors.primary.
//? Offline: red wifi-slash icon + "Offline" in AppColors.errorSolid.

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ZoneDeviceBadge Widget
class ZoneDeviceBadge extends StatelessWidget {
  final bool isOnline;

  //* StatelessWidget — receives device status
  const ZoneDeviceBadge({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Container with AppColors.darkPanelCard (dark) or AppColors.lightElevatedCard (light) background
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPanelCard : AppColors.lightElevatedCard,
        borderRadius: BorderRadius.circular(8),
      ),
      //* Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Text("DEVICE STATE") AppTypography.overlineXS muted
          Text(
            'DEVICE STATE',
            style: AppTypography.overlineXS.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
            ),
          ),
          const SizedBox(height: 8),
          //* Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Icon(isOnline ? PhosphorIcons.wifiHigh : PhosphorIcons.wifiSlash)
              Icon(
                isOnline ? PhosphorIcons.wifiHigh() : PhosphorIcons.wifiSlash(),
                size: 16,
                color: isOnline ? AppColors.primary : AppColors.errorSolid,
              ),
              const SizedBox(width: 6),
              //* Text(isOnline ? "Online" : "Offline") AppTypography.bodySMedium
              Text(
                isOnline ? 'Online' : 'Offline',
                style: AppTypography.bodySMedium.copyWith(
                  color: isOnline ? AppColors.primary : AppColors.errorSolid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
