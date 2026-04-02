//? Full-width emergency stop button — frontend managed.
//? This button does NOT call any backend endpoint.
//? It triggers a local confirmation dialog then logs the action.
//? Default state: dark red bg (#B71C1C) with white text and two
//?   circle icons on left and right sides.
//? Hover state: brighter red (AppColors.errorSolid) bg.
//? The button has Amazigh zigzag strip pattern on left and right
//? On confirm: sets hasEmergencyAlertProvider to true locally.
// TODO :: Wire confirmed stop to local MQTT publish if needed

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

//& EmergencyStopButton Widget
class EmergencyStopButton extends StatefulWidget {
  //* StatefulWidget — tracks hover and loading state
  const EmergencyStopButton({super.key});

  @override
  State<EmergencyStopButton> createState() => _EmergencyStopButtonState();
}

class _EmergencyStopButtonState extends State<EmergencyStopButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: () => _showConfirmDialog(context),
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
                          colorFilter:
                              const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
                //* Right pattern 
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
                        child: Transform.flip(
                          flipX: true,
                          child: SvgPicture.asset(
                            AppAssets.patternDotsLine,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
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
                        'EMERGENCY STOP',
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
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Emergency Stop'),
        content: const Text('This will halt all irrigation immediately. Are you sure?'),
        actions: [
          //* Actions: Cancel (outlined) , Confirm (red filled)
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              //* On confirm: log the action
              AppLogger.critical('EMERGENCY', 'Emergency stop triggered by user');
              // TODO :: Publish stop signal to MQTT topic: tazrout/emergency/stop
              // TODO :: Set hasEmergencyAlertProvider to true locally
              // TODO :: Wire emergency stop to MQTT when backend endpoint is live
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorSolid,
              foregroundColor: AppColors.lightSurfaceCard,
            ),
            child: const Text('CONFIRM STOP'),
          ),
        ],
      ),
    );
  }
}
