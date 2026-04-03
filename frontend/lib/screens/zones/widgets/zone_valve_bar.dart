//? Full-width bottom bar showing valve state.
//? Open: droplet icon + "Open" in AppColors.series2Blue.
//? Closed: lock icon + "Closed" in AppColors.darkMutedText.
//? Background: AppColors.darkBase (dark) or lightElevatedCard (light).

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ZoneValveBar Widget
class ZoneValveBar extends StatelessWidget {
  final bool isValveOpen;
  final bool isOnline;

  //* StatelessWidget — receives valve state and online status
  const ZoneValveBar({
    super.key,
    required this.isValveOpen,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    //* Container full width, height 44px, borderRadius bottom 8px
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBase : AppColors.lightElevatedCard,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      //* Row mainAxisAlignment: center
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* Text("VALVE STATE") AppTypography.overlineXS muted
          Text(
            l10n.valveState,
            style: AppTypography.overlineXS.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
            ),
          ),
          const SizedBox(width: 12),
          //* Valve icon
          isValveOpen
              ? SvgPicture.asset(
                  isDark ? AppAssets.darkIconWaterI : AppAssets.lightIconWaterI,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.series2Blue,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  isDark ? AppAssets.darkIconWaterValveClosed : AppAssets.lightIconWaterValveClosed,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    BlendMode.srcIn,
                  ),
                ),
          const SizedBox(width: 6),
          //* Text(isValveOpen ? "Open" : "Closed") AppTypography.bodySMedium
          Text(
            isValveOpen ? l10n.open : l10n.closed,
            style: AppTypography.bodySMedium.copyWith(
              color: isValveOpen 
                  ? AppColors.series2Blue 
                  : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
            ),
          ),
        ],
      ),
    );
  }
}
