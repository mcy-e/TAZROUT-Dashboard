//? Center card showing system health status.
//? Background carries a subtle Amazigh pattern overlay at low opacity.
//? Icon is green check (healthy) or orange emergency icon based on status.
//? Wired to MQTT topic: tazrout/dashboard/summary via zonesProvider.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../providers/zone_provider.dart';

//& WelcomeCard
class WelcomeCard extends ConsumerStatefulWidget {
  const WelcomeCard({super.key});

  @override
  ConsumerState<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends ConsumerState<WelcomeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final zones = ref.watch(zonesProvider);
    final hasOfflineZones = zones.any((z) => !z.isOnline);
    final isHealthy = !hasOfflineZones && zones.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //* Bottom glow — stronger on hover
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 80,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.2,
                    colors: [
                      (isHealthy ? AppColors.primary : AppColors.warningSolid).withValues(alpha: _isHovered ? 0.18 : 0.07),
                      (isHealthy ? AppColors.primary : AppColors.warningSolid).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            //* symbolWisdom top-left — always visible, brightens on hover
            Positioned(
              top: 12,
              left: 12,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: _isHovered ? 0.55 : 0.20,
                child: SvgPicture.asset(
                  AppAssets.symbolWisdom,
                  height: 56,
                  colorFilter: ColorFilter.mode(
                    isHealthy ? AppColors.primary : AppColors.warningSolid,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            //* Main content — always on top, centered
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //* Green check circle icon
                    if (isHealthy)
                      SvgPicture.asset(
                        isDark ? AppAssets.darkIconChecked : AppAssets.lightIconChecked,
                        height: 32,
                      )
                    else
                    SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconEmergencyActive
                            : AppAssets.lightIconEmergencyActive,
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFF97316),
                          BlendMode.srcIn,
                        ),
                      ),
                    const SizedBox(height: 12),
                    //* Welcome title
                    Text(
                      l10n.welcomeBack,
                      textAlign: isArabic(context) ? TextAlign.right : TextAlign.center,
                      style: AppTypography.headingM.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    //* Status description text
                    Text(
                      isHealthy ? l10n.systemStatus : 'Some zones offline',
                      textAlign: isArabic(context) ? TextAlign.right : TextAlign.center,
                      style: AppTypography.bodySRegular.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.lightBodyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
