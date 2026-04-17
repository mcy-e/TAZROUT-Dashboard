//? Modal dialog showing QR code + contact info.
//? Triggered from SupportBanner "Get Support" button.
//? Shows: heading, subtitle, QR image placeholder, website row,
//?   phone row, and support availability banner below card.
//? Amazigh triangular chevron pattern on card sides — Antigravity.
//? QR code: static green placeholder box for now.
// TODO :: Load phone and URL from GET /api/v1/support/contact
// TODO :: Generate QR from URL using qr_flutter package (later)

//& Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/locale_text_direction.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/sleep_provider.dart';

//& QrContactCard Widget
class QrContactCard extends ConsumerWidget {
  //* QrContactCard — displays QR code and contact info in a dialog
  const QrContactCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isSleepingProvider, (previous, next) {
      if (next == true) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: ConstrainedBox(
        //* Dialog maxWidth: 400px
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Card body
            Card(
              margin: EdgeInsets.zero,
              color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    //* Left pattern strip
                    Positioned(
                      left: 0, top: 0, bottom: 0,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SvgPicture.asset(
                            AppAssets.patternFilledTriangleBand,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              AppColors.primary.withValues(alpha: 0.25),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //* Right pattern strip — flipped
                    Positioned(
                      right: 0, top: 0, bottom: 0,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Transform.flip(
                          flipX: true,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: SvgPicture.asset(
                              AppAssets.patternFilledTriangleBand,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                AppColors.primary.withValues(alpha: 0.25),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //* Close button — positioned top-right of card
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.darkMutedText,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: l10n.closeTooltip,
                      ),
                    ),
                    //* Foreground content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.helpMoreHelpTitle,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.headingM.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.helpScanCodeCall,
                          textAlign: TextAlign.center,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.bodySRegular.copyWith(
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                        ),
                        const SizedBox(height: 24),
                        //* QR code placeholder
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.primary10,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              PhosphorIcons.qrCode(),
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // TODO :: Replace with QrImageView widget
                        const SizedBox(height: 24),
                        //* Website row — DATA placeholder URL
                        _ContactRow(
                          icon: Icon(PhosphorIcons.globe(), size: 20, color: AppColors.primary),
                          text: 'Tazrout/help.com',
                          onTap: () => AppLogger.info('HELP', 'Website tapped'),
                          // TODO :: Open URL via url_launcher
                        ),
                        const SizedBox(height: 12),
                        //* Phone row — DATA placeholder
                        _ContactRow(
                          icon: Icon(PhosphorIcons.phone(), size: 20, color: AppColors.primary),
                          text: '+213-55-55-55-55',
                          onTap: () => AppLogger.info('HELP', 'Phone tapped'),
                          // TODO :: Copy to clipboard or open dialler
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
            const SizedBox(height: 12),
            //* Support availability banner below card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPanelCard : AppColors.lightElevatedCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.question(),
                    size: 16,
                    color: AppColors.darkMutedText,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySRegular.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.helpSupportFooterBold,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                          ),
                          TextSpan(
                            text: l10n.helpSupportFooterRest,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//& _ContactRow (private, same file)
class _ContactRow extends StatefulWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //* Background + Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            //* Minimum 48px tap target for touch screen compatibility
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primary10
                  : (isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
              ),
            ),
            child: Row(
              children: [
                //* Left: type indicator icon
                widget.icon,
                const SizedBox(width: 12),
                //* Center: label text
                Expanded(
                  child: Text(
                    widget.text,
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.bodySRegular.copyWith(
                      color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //* Top-Left pattern
          Positioned(
            top: -28, left: -28,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                child: SvgPicture.asset(AppAssets.berberIconDiamondSun, width: 56, height: 56),
              ),
            ),
          ),
          //* Bottom-Right pattern
          Positioned(
            bottom: -28, right: -28,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                child: SvgPicture.asset(AppAssets.berberIconDiamondSun, width: 56, height: 56),
              ),
            ),
          ),
          //* Ripple and Hover detection
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(8),
                onHover: (hovered) => setState(() => _isHovered = hovered),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
