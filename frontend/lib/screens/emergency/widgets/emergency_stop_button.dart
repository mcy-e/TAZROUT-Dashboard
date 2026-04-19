//? Full-width emergency stop button — frontend managed.
//? This button does NOT call any backend endpoint.
//? It triggers a local confirmation dialog then logs the action.
//? Default state: dark red bg (#B71C1C) with white text and two
//?   circle icons on left and right sides.
//? Hover state: brighter red (AppColors.errorSolid) bg.
//? The button has Amazigh zigzag strip pattern on left and right sides
//? On confirm: sets hasEmergencyAlertProvider to true locally.
// TODO :: Wire confirmed stop to local MQTT publish if needed

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../providers/navigation_provider.dart';
import '../../../../providers/system_provider.dart';

//& EmergencyStopButton Widget
class EmergencyStopButton extends ConsumerStatefulWidget {
  //* ConsumerStatefulWidget — tracks hover and loading state
  const EmergencyStopButton({super.key});

  @override
  ConsumerState<EmergencyStopButton> createState() => _EmergencyStopButtonState();
}

class _EmergencyStopButtonState extends ConsumerState<EmergencyStopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: () => _showConfirmDialog(context, l10n),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: Stack(
              fit: StackFit.expand,
              children: [
                //* Background color
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  color: _isHovered
                      ? AppColors.errorSolid.withValues(alpha: 0.82)
                      : AppColors.errorSolid,
                ),
                //* Left pattern
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 24,
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: ClipRect(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: SvgPicture.asset(
                          AppAssets.patternDotsLine,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            AppColors.lightSurfaceCard,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //* Right pattern — no flip; mirror of left strip
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 24,
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: ClipRect(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: SvgPicture.asset(
                          AppAssets.patternDotsLine,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            AppColors.lightSurfaceCard,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //* Center row always on top
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.darkIconEmergencyButton,
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        l10n.emergencyStop,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.overlineS.copyWith(
                          color: AppColors.lightSurfaceCard,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        AppAssets.darkIconEmergencyButton,
                        width: 28,
                        height: 28,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //* On tap: show AlertDialog confirmation
  void _showConfirmDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.emergencyStopConfirmTitle,
          textDirection: textDirectionForUiLocale(dialogContext),
        ),
        content: Text(
          l10n.emergencyStopConfirmBody,
          textDirection: textDirectionForUiLocale(dialogContext),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              textDirection: textDirectionForUiLocale(dialogContext),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                //* Fire instant stop signal via SystemRepository
                await ref.read(systemControlsProvider).emergencyStop();
                
                //* Set local alert state to true
                ref.read(hasEmergencyAlertProvider.notifier).state = true;
                
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (e) {
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorSolid,
              foregroundColor: AppColors.lightSurfaceCard,
            ),
            child: Text(
              l10n.confirmEmergencyStop,
              textDirection: textDirectionForUiLocale(dialogContext),
            ),
          ),
        ],
      ),
    );
  }
}
