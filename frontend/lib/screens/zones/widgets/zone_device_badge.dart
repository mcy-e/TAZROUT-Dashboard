//? Small badge showing DEVICE STATE label + wifi icon + status text.
//? Online: green wifi icon + "Online" in AppColors.primary.
//? Offline: red wifi-slash icon + "Offline" in AppColors.errorSolid.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/app_assets.dart';
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
    final l10n = AppLocalizations.of(context)!;

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
            l10n.deviceState,
            style: AppTypography.overlineXS.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
            ),
          ),
          const SizedBox(height: 8),
          //* Row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* SvgPicture.asset based on status and theme
              SvgPicture.asset(
                isOnline
                    ? (isDark
                        ? AppAssets.darkIconConnectionState
                        : AppAssets.lightIconConnectionState)
                    : (isDark
                        ? AppAssets.darkIconConnectionStateClosed
                        : AppAssets.lightIconConnectionStateClosed),
                height: 16,
                colorFilter: ColorFilter.mode(
                  isOnline ? AppColors.primary : AppColors.errorSolid,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              //* Text(isOnline ? "Online" : "Offline") AppTypography.bodySMedium
              Text(
                isOnline ? l10n.online : l10n.offline,
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
