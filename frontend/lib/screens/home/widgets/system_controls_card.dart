//? Card with REBOOT and SHUT DOWN buttons.
//? Both buttons are outlined, full width, with phosphor icons.
//? Hover state: border and text turn AppColors.primary.
//? On confirm: shows a modal dialog before executing.
// TODO :: Wire to MQTT topic: tazrout/system/control

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';

//& SystemControlsCard
class SystemControlsCard extends ConsumerWidget {
  //* Card with title "System Controls" using AppTypography.headingXS
  const SystemControlsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Header Row with Title and Test Trigger
            Row(
              children: [
                Text(
                  'System Controls',
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const Spacer(),
                //* Test notification trigger — remove after MQTT is wired
                //* Accessible via a small debug IconButton in the card header
                // TODO :: Remove test trigger when MQTT events are live
                IconButton(
                  icon: Icon(
                    PhosphorIcons.bellRinging(),
                    size: 16,
                    color: AppColors.darkMutedText,
                  ),
                  tooltip: 'Test notification',
                  onPressed: () {
                    ref.read(notificationProvider.notifier).add(
                          NotificationModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            type: NotificationType.sensorAlert,
                            title: 'Zone C Offline',
                            message: 'Device lost connection. Check gateway.',
                            timestamp: DateTime.now(),
                          ),
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            //* Two full-width outlined buttons stacked vertically with 12px gap
            //* REBOOT button
            _ControlButton(
              // TODO :: Wire to MQTT topic: tazrout/system/control
              label: 'REBOOT',
              icon: PhosphorIcons.arrowCounterClockwise(),
              onPressed: () => _showConfirmDialog(context, 'REBOOT'),
            ),
            const SizedBox(height: 12),
            //* SHUT DOWN button
            _ControlButton(
              // TODO :: Wire to MQTT topic: tazrout/system/control
              label: 'SHUT DOWN',
              icon: PhosphorIcons.power(),
              onPressed: () => _showConfirmDialog(context, 'SHUT DOWN'),
            ),
          ],
        ),
      ),
    );
  }

  //* On tap: show confirmation AlertDialog before logging the action
  void _showConfirmDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm $action'),
        content: Text('Are you sure you want to $action the system?'),
        actions: [
          //* Minimum 48px tap target for touch screen compatibility
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
            ),
            child: const Text('CANCEL'),
          ),
          //* Minimum 48px tap target for touch screen compatibility
          TextButton(
            onPressed: () {
              //* Log the action
              AppLogger.info('SYSTEM', 'User triggered $action');
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
            ),
            child: const Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Visual state driven by _isHovered OR press state
    final Color borderColor = _isHovered
        ? AppColors.primary
        : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider);
    
    final Color contentColor = _isHovered
        ? AppColors.primary
        : (isDark ? AppColors.darkBodyText : AppColors.lightBodyText);

    //* Dual input: MouseRegion for mouse hover, InkWell for touch press
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          //* Minimum 48px tap target for touch screen compatibility
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 20, color: contentColor),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTypography.bodyMBold.copyWith(
                  color: contentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
