//? Stacks all active notification toasts in top-right corner.
//? Positioned fixed over all screen content.
//? New toasts appear at top, older ones shift down.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/notification_sound.dart';
import '../../providers/notification_provider.dart';
import '../../providers/preferences_provider.dart';
import 'notification_toast.dart';

//& NotificationOverlay Widget
class NotificationOverlay extends ConsumerStatefulWidget {
  //* ConsumerStatefulWidget — watches notificationProvider + plays sound
  const NotificationOverlay({super.key});

  @override
  ConsumerState<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends ConsumerState<NotificationOverlay> {
  int _lastCount = 0;

  Future<void> _playNotificationSound() async {
    playNotificationSoundIfEnabled(ref.read(preferencesProvider).soundAlerts);
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);

    if (notifications.length > _lastCount) {
      _playNotificationSound();
    }
    _lastCount = notifications.length;

    //* Positioned top-right: top 24px, right 24px
    return Positioned(
      top: 24,
      right: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //* For each notification in state:
          for (final n in notifications)
            NotificationToast(
              key: ValueKey(n.id),
              notification: n,
              onDismiss: () {
                ref.read(notificationProvider.notifier).remove(n.id);
              },
            ),
        ],
      ),
    );
  }
}
