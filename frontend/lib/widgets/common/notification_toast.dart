//? Single dismissible notification toast card.
//? Slides in from top-right on mount.
//? Auto-dismisses after 5 seconds.
//? Sensor alerts: amber left border + warning icon.
//? AI decisions: blue left border + robot/cpu icon.

//& Imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/notification_model.dart';

//& NotificationToast Widget
class NotificationToast extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onDismiss;

  //* NotificationToast Parameters
  const NotificationToast({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<NotificationToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    
    //* Animation Setup: 300ms duration, easeOut curve
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    //* Auto-dismiss: Timer(Duration(seconds: 5), onDismiss)
    _dismissTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _handleDismiss();
      }
    });
  }

  void _handleDismiss() {
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    //* Dispose both in dispose()
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSensorAlert = widget.notification.type == NotificationType.sensorAlert;
    final accentColor = isSensorAlert ? AppColors.series3Amber : AppColors.series2Blue;
    final formattedTime = DateFormat('HH:mm:ss').format(widget.notification.timestamp);

    //* SlideTransition + FadeTransition wrapping
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 320,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            //* bg: AppColors.darkElevatedCard (dark) / AppColors.lightSurfaceCard (light)
            color: isDark ? AppColors.darkElevatedCard : AppColors.lightSurfaceCard,
            borderRadius: BorderRadius.circular(8),
            //* border left 4px
            border: Border(
              left: BorderSide(color: accentColor, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Type icon
              Icon(
                isSensorAlert ? PhosphorIcons.warning() : PhosphorIcons.cpu(),
                size: 20,
                color: accentColor,
              ),
              const SizedBox(width: 12),
              //* Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //* Text(notification.title) AppTypography.bodySBold
                    Text(
                      widget.notification.title,
                      style: AppTypography.bodySBold.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //* Text(notification.message) AppTypography.bodySRegular muted
                    Text(
                      widget.notification.message,
                      style: AppTypography.bodySRegular.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //* Text(formattedTime) AppTypography.labelXSRegular muted
                    Text(
                      formattedTime,
                      style: AppTypography.labelXSRegular.copyWith(
                        color: isDark ? AppColors.darkSubtleText : AppColors.lightMutedText,
                      ),
                    ),
                  ],
                ),
              ),
              //* Dismiss button
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                color: AppColors.darkMutedText,
                onPressed: _handleDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
