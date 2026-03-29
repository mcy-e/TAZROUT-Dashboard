//? Full-width dark support banner with CTA button.
//? Dark green background (AppColors.darkSidebar both themes).
//? Amazigh symbol decorations on corners.
//? Has a large muted lifesaver/lifebuoy icon on the right side.
//? Get Support button triggers QrContactCard dialog.

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

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
                //* Text("Still need assistance?") AppTypography.headingS color: Colors.white
                Text(
                  'Still need assistance?',
                  style: AppTypography.headingS.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                //* Text description
                Text(
                  'Our support team is available 24/7 to help you resolve any issues regarding the system.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                //* Get Support button
                OutlinedButton.icon(
                  onPressed: () {
                    AppLogger.info('HELP', 'Get Support button tapped');
                    onGetSupport();
                  },
                  icon: Icon(
                    PhosphorIcons.arrowRight(),
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Get Support',
                    style: AppTypography.bodySMedium.copyWith(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
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
