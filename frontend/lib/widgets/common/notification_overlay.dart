//? Stacks all active notification toasts in top-right corner.
//? Positioned fixed over all screen content.
//? New toasts appear at top, older ones shift down.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notification_provider.dart';
import 'notification_toast.dart';

//& NotificationOverlay Widget
class NotificationOverlay extends ConsumerWidget {
  //* ConsumerWidget — watches notificationProvider
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);

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
              onDismiss: () => ref.read(notificationProvider.notifier).remove(n.id),
            ),
        ],
      ),
    );
  }
}
