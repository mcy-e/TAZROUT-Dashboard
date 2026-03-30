//? Modal dialog showing QR code + contact info.
//? Triggered from SupportBanner "Get Support" button.
//? Shows: heading, subtitle, QR image placeholder, website row,
//?   phone row, and support availability banner below card.
//? Amazigh triangular chevron pattern on card sides — Antigravity.
//? QR code: static green placeholder box for now.
// TODO :: Load phone and URL from GET /api/v1/support/contact
// TODO :: Generate QR from URL using qr_flutter package (later)

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

//& QrContactCard Widget
class QrContactCard extends StatelessWidget {
  //* QrContactCard — displays QR code and contact info in a dialog
  const QrContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              child: Stack(
                children: [
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
                      tooltip: 'Close',
                    ),
                  ),
                  //* Foreground content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* Text("More Help ?") AppTypography.headingM
                        Text(
                          'More Help ?',
                          style: AppTypography.headingM.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        //* Description
                        Text(
                          'Scan the code below or call the following number for More Help.',
                          textAlign: TextAlign.center,
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
                        //* Website row
                        _ContactRow(
                          icon: PhosphorIcons.globe(),
                          text: 'Tazrout/help.com',
                          onTap: () => AppLogger.info('HELP', 'Website tapped'),
                          // TODO :: Open URL via url_launcher
                        ),
                        const SizedBox(height: 12),
                        //* Phone row
                        _ContactRow(
                          icon: PhosphorIcons.phone(),
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
            const SizedBox(height: 12),
            //* Support availability banner below card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                //* bg: AppColors.darkPanelCard (dark) / AppColors.lightElevatedCard (light)
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
                            text: 'Still need assistance? ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                          ),
                          const TextSpan(text: 'Our support team is available 24/7...'),
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
  final IconData icon;
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

    //* MouseRegion + InkWell
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          //* Minimum 48px tap target for touch screen compatibility
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            //* default bg: AppColors.darkElevatedCard (dark) / AppColors.lightElevatedCard (light)
            //* hover bg: AppColors.primary10
            color: _isHovered
                ? AppColors.primary10
                : (isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                widget.text,
                style: AppTypography.bodySMedium.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
