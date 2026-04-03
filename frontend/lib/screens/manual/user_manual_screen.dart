//? User manual screen — displays embedded documentation viewer.
//? All manual content is frontend-managed in docs/user-manuals/.
//? No MQTT or backend calls required for this screen.

//& Imports
import 'package:flutter/material.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../core/utils/app_logger.dart';
import 'widgets/document_viewer_card.dart';

//& UserManualScreen Widget
class UserManualScreen extends StatefulWidget {
  //* StatelessWidget — displays the user manual documentation
  const UserManualScreen({super.key});

  @override
  State<UserManualScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  @override
  void initState() {
    super.initState();
    //* Log screen activation
    AppLogger.info('MANUAL', 'User Manual screen loaded');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            //* Page header
            Text(
              l10n.userManualTitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.headingM.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            Text(
              l10n.manualSubtitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.bodySRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 24),
            //* Main document viewer
            const Expanded(
              child: DocumentViewerCard(),
            ),
            const SizedBox(height: 12),
            //* External footer
            Center(
              child: Text(
                l10n.manualFooterMeta,
                textDirection: textDirectionForUiLocale(context),
                style: AppTypography.labelXSRegular.copyWith(
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
