//? Card with REBOOT and SHUT DOWN buttons.
//? Both buttons are outlined, full width, with phosphor icons.
//? Hover state: border and text turn AppColors.primary.
//? On confirm: shows a modal dialog before executing.
// TODO :: Wire to MQTT topic: tazrout/system/control

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';

//& SystemControlsCard
class SystemControlsCard extends ConsumerWidget {
  //* Card with title "System Controls" using AppTypography.headingXS
  const SystemControlsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            //* Header Row with Title and Test Trigger
            Row(
              children: isArabic(context)
                  ? [
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.bellRinging(),
                          size: 16,
                          color: AppColors.darkMutedText,
                        ),
                        tooltip: l10n.tooltipTestNotification,
                        onPressed: () {
                          ref.read(notificationProvider.notifier).add(
                                NotificationModel(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  type: NotificationType.sensorAlert,
                                  // DATA — no l10n, comes from MQTT/API
                                  title: l10n.testNotificationTitle,
                                  message: l10n.testNotificationMessage,
                                  timestamp: DateTime.now(),
                                ),
                              );
                        },
                      ),
                      const Spacer(),
                      Text(
                        l10n.systemControls,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingXS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        l10n.systemControls,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
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
                        tooltip: l10n.tooltipTestNotification,
                        onPressed: () {
                          ref.read(notificationProvider.notifier).add(
                                NotificationModel(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  type: NotificationType.sensorAlert,
                                  // DATA — no l10n, comes from MQTT/API
                                  title: l10n.testNotificationTitle,
                                  message: l10n.testNotificationMessage,
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
            _AnimatedRebootButton(
              onConfirmRequested: () => _showConfirmDialog(context, _SystemAction.reboot),
            ),
            const SizedBox(height: 12),
            //* SHUT DOWN button
            _ControlButton(
              // TODO :: Wire to MQTT topic: tazrout/system/control
              label: l10n.shutdown,
              darkIcon: AppAssets.darkIconShutDownI,
              lightIcon: AppAssets.lightIconShutDownI,
              hoverDarkIcon: AppAssets.darkIconShutDownH,
              hoverLightIcon: AppAssets.lightIconShutDownH,
              hoverColor: AppColors.errorSolid,
              onPressed: () => _showConfirmDialog(context, _SystemAction.shutdown),
            ),
          ],
        ),
      ),
    );
  }

  //* On tap: show confirmation AlertDialog before logging the action
  Future<bool> _showConfirmDialog(BuildContext context, _SystemAction action) async {
    final l10n = AppLocalizations.of(context)!;
    final body = action == _SystemAction.reboot ? l10n.confirmRebootBody : l10n.confirmShutdownBody;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.confirmActionTitle,
          textDirection: textDirectionForUiLocale(context),
        ),
        content: Text(
          body,
          textDirection: textDirectionForUiLocale(context),
        ),
        actions: [
          //* Minimum 48px tap target for touch screen compatibility
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
            ),
            child: Text(
              l10n.cancel,
              textDirection: textDirectionForUiLocale(context),
            ),
          ),
          //* Minimum 48px tap target for touch screen compatibility
          TextButton(
            onPressed: () {
              //* Log the action
              final actionLabel = action == _SystemAction.reboot ? l10n.reboot : l10n.shutdown;
              AppLogger.info('SYSTEM', 'User triggered $actionLabel');
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
            ),
            child: Text(
              l10n.confirm,
              textDirection: textDirectionForUiLocale(context),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

//& _SystemAction
enum _SystemAction { reboot, shutdown }

class _AnimatedRebootButton extends StatefulWidget {
  final Future<bool> Function() onConfirmRequested;

  const _AnimatedRebootButton({required this.onConfirmRequested});

  @override
  State<_AnimatedRebootButton> createState() => _AnimatedRebootButtonState();
}

class _AnimatedRebootButtonState extends State<_AnimatedRebootButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    final confirmed = await widget.onConfirmRequested();
    if (confirmed) {
      _spinController.repeat();
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _spinController.stop();
        _spinController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = _isHovered
        ? AppColors.primary
        : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider);

    final Color contentColor = _isHovered
        ? AppColors.primary
        : (isDark ? AppColors.darkBodyText : AppColors.lightBodyText);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isArabic(context)
                ? [
                    Text(
                      AppLocalizations.of(context)!.reboot,
                      textAlign: TextAlign.right,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySMedium.copyWith(
                        color: contentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    //* Spinning reboot icon using RotationTransition
                    RotationTransition(
                      turns: _spinController,
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 150),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                          crossFadeState: _isHovered
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: SvgPicture.asset(
                            isDark ? AppAssets.darkIconRebootI : AppAssets.lightIconRebootI,
                            height: 18,
                            colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                          ),
                          secondChild: SvgPicture.asset(
                            isDark ? AppAssets.darkIconRebootH : AppAssets.lightIconRebootH,
                            height: 18,
                            colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    //* Spinning reboot icon using RotationTransition
                    RotationTransition(
                      turns: _spinController,
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 150),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                          crossFadeState: _isHovered
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: SvgPicture.asset(
                            isDark ? AppAssets.darkIconRebootI : AppAssets.lightIconRebootI,
                            height: 18,
                            colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                          ),
                          secondChild: SvgPicture.asset(
                            isDark ? AppAssets.darkIconRebootH : AppAssets.lightIconRebootH,
                            height: 18,
                            colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.reboot,
                      textAlign: TextAlign.left,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySMedium.copyWith(
                        color: contentColor,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final String label;
  final String darkIcon;
  final String lightIcon;
  final String hoverDarkIcon;
  final String hoverLightIcon;
  final Color hoverColor;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.label,
    required this.darkIcon,
    required this.lightIcon,
    required this.hoverDarkIcon,
    required this.hoverLightIcon,
    required this.hoverColor,
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
        ? widget.hoverColor
        : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider);

    final Color contentColor = _isHovered
        ? widget.hoverColor
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
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isArabic(context)
                ? [
                    Text(
                      widget.label.toUpperCase(),
                      textAlign: TextAlign.right,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySMedium.copyWith(
                        color: contentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 150),
                        firstCurve: Curves.easeInOut,
                        secondCurve: Curves.easeInOut,
                        crossFadeState: _isHovered
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: SvgPicture.asset(
                          isDark ? widget.darkIcon : widget.lightIcon,
                          height: 18,
                          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                        ),
                        secondChild: SvgPicture.asset(
                          isDark ? widget.hoverDarkIcon : widget.hoverLightIcon,
                          height: 18,
                          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ]
                : [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 150),
                        firstCurve: Curves.easeInOut,
                        secondCurve: Curves.easeInOut,
                        crossFadeState: _isHovered
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: SvgPicture.asset(
                          isDark ? widget.darkIcon : widget.lightIcon,
                          height: 18,
                          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                        ),
                        secondChild: SvgPicture.asset(
                          isDark ? widget.hoverDarkIcon : widget.hoverLightIcon,
                          height: 18,
                          colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.label.toUpperCase(),
                      textAlign: TextAlign.left,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySMedium.copyWith(
                        color: contentColor,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
