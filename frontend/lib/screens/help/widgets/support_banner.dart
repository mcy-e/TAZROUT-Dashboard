//? Full-width dark support banner with CTA button.
//? Dark green background (AppColors.darkSidebar both themes).
//? Amazigh symbol decorations on corners.
//? Has a large muted lifesaver/lifebuoy icon on the right side.
//? Get Support button triggers QrContactCard dialog.

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/locale_text_direction.dart';

//& SupportBanner Widget
class SupportBanner extends StatelessWidget {
  final VoidCallback onGetSupport;

  //* SupportBanner Parameters
  const SupportBanner({
    super.key,
    required this.onGetSupport,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    //* Container full width, borderRadius 12px, padding 24px
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        //* bg: AppColors.darkSidebar (dark) / AppColors.darkElevatedCard (light)
        color: isDark ? AppColors.darkSidebar : AppColors.darkElevatedCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          //* Background right-side icon — muted lifebuoy
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Icon(
              PhosphorIcons.lifebuoy(),
              size: 80,
              color: AppColors.darkStrokeDivider.withValues(alpha: 0.4),
            ),
          ),
          //* Foreground content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.supportStillNeedTitle,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.headingS.copyWith(color: AppColors.lightSurfaceCard),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.supportTeamAvailable,
                  textAlign: TextAlign.center,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.bodySRegular.copyWith(
                    color: AppColors.lightSurfaceCard.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    AppLogger.info('HELP', 'Get Support button tapped');
                    onGetSupport();
                  },
                  icon: Icon(
                    PhosphorIcons.arrowRight(),
                    size: 16,
                    color: AppColors.lightSurfaceCard,
                  ),
                  label: Text(
                    l10n.supportGetSupport,
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.bodySMedium.copyWith(color: AppColors.lightSurfaceCard),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.lightSurfaceCard),
                    minimumSize: const Size(140, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
}
