//? Full-width bottom bar showing valve state.
//? Open: droplet icon + "Open" in AppColors.series2Blue.
//? Closed: lock icon + "Closed" in AppColors.darkMutedText.
//? Background: AppColors.darkBase (dark) or lightElevatedCard (light).

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
            'VALVE STATE',
            style: AppTypography.overlineXS.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
            ),
          ),
          const SizedBox(width: 12),
          //* Icon(isValveOpen ? PhosphorIcons.drop : PhosphorIcons.lock)
          Icon(
            isValveOpen ? PhosphorIcons.drop() : PhosphorIcons.lock(),
            size: 16,
            color: isValveOpen ? AppColors.series2Blue : AppColors.darkMutedText,
          ),
          const SizedBox(width: 6),
          //* Text(isValveOpen ? "Open" : "Closed") AppTypography.bodySMedium
          Text(
            isValveOpen ? 'Open' : 'Closed',
            style: AppTypography.bodySMedium.copyWith(
              color: isValveOpen ? AppColors.series2Blue : AppColors.darkMutedText,
            ),
          ),
        ],
      ),
    );
  }
}
