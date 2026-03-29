//? Full-width emergency stop button — frontend managed.
//? This button does NOT call any backend endpoint.
//? It triggers a local confirmation dialog then logs the action.
//? Default state: dark red bg (#B71C1C) with white text and two
//?   circle icons on left and right sides.
//? Hover state: brighter red (AppColors.errorSolid) bg.
//? The button has Amazigh zigzag strip pattern on left and right
//?   edges — defer pattern rendering to Antigravity.
//? On confirm: sets hasEmergencyAlertProvider to true locally.
// TODO :: Wire confirmed stop to local MQTT publish if needed

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    //* MouseRegion + InkWell dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => _showConfirmDialog(context),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            //* Default bg: Color(0xFFB71C1C), Hover bg: AppColors.errorSolid
            color: _isHovered ? AppColors.errorSolid : const Color(0xFFB71C1C),
            borderRadius: BorderRadius.circular(8),
          ),
          //* Inner Row
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIcons.prohibit(), size: 28, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                'E M E R G E N C Y  S T O P',
                style: AppTypography.headingM.copyWith(
                  color: Colors.white,
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(width: 16),
              Icon(PhosphorIcons.prohibit(), size: 28, color: Colors.white),
            ],
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
          //* Actions: Cancel (outlined) | Confirm (red filled)
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
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorSolid,
              foregroundColor: Colors.white,
            ),
            child: const Text('CONFIRM STOP'),
          ),
        ],
      ),
    );
  }
}
