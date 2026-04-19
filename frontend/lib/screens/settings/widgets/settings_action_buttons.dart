//? Reset Default and Apply Settings buttons.
//? Reset Default: outlined button, reverts all local state to defaults.
//? Apply Settings: filled green button, saves preferences.
//? Both use hover states and confirmation where appropriate.
// TODO :: Apply Settings triggers MQTT publish: tazrout/settings/preferences

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../providers/preferences_provider.dart';

//& SettingsActionButtons Widget
class SettingsActionButtons extends ConsumerWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  //* SettingsActionButtons Parameters
  const SettingsActionButtons({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //* Reset Default Button
        Flexible(
          child: _ResetDefaultButton(onPressed: onReset),
        ),
        const SizedBox(width: 12),
        //* Apply Settings Button
        Flexible(
          child: _ApplySettingsButton(onPressed: onApply),
        ),
      ],
    );
  }
}

//& SettingsConfirmType Enum
enum SettingsConfirmType { reset, apply }

//& _showSettingsConfirmDialog
void _showSettingsConfirmDialog(
  BuildContext context,
  SettingsConfirmType type,
) {
  showDialog<void>(
    context: context,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final l10n = AppLocalizations.of(ctx)!;
      final message = type == SettingsConfirmType.reset ? l10n.settingsReset : l10n.settingsApplied;

      return AlertDialog(
        backgroundColor: isDark ? AppColors.darkElevatedCard : AppColors.lightSurfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          message,
          textDirection: textDirectionForUiLocale(ctx),
          style: AppTypography.headingXS.copyWith(
            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.ok,
              textDirection: textDirectionForUiLocale(ctx),
              style: AppTypography.bodySMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}

//& _ResetDefaultButton
class _ResetDefaultButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  const _ResetDefaultButton({required this.onPressed});

  @override
  ConsumerState<_ResetDefaultButton> createState() => _ResetDefaultButtonState();
}

class _ResetDefaultButtonState extends ConsumerState<_ResetDefaultButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final animDuration = ref.watch(preferencesProvider).animDuration;
    final borderColor = _isHovered
        ? (isDark ? AppColors.darkBodyText : AppColors.lightPrimaryText)
        : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider);
    final transparentSurface = AppColors.lightSurfaceCard.withValues(alpha: 0.0);
    final hoverTint = (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
        .withValues(alpha: 0.35);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120, minHeight: 48),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () async {
            widget.onPressed();
            await Future.delayed(const Duration(milliseconds: 150));
            if (context.mounted) {
              _showSettingsConfirmDialog(context, SettingsConfirmType.reset);
            }
          },
          child: SizedBox(
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //* Button background + border
                  AnimatedContainer(
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _isHovered ? hoverTint : transparentSurface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                    ),
                  ),
                  //* Label always on top
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.resetDefault,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.bodySMedium.copyWith(
                            color:
                                isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//& _ApplySettingsButton
class _ApplySettingsButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  const _ApplySettingsButton({required this.onPressed});

  @override
  ConsumerState<_ApplySettingsButton> createState() => _ApplySettingsButtonState();
}

class _ApplySettingsButtonState extends ConsumerState<_ApplySettingsButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final animDuration = ref.watch(preferencesProvider).animDuration;
    final bgColor = _isHovered ? AppColors.primaryDark : AppColors.primary;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120, minHeight: 48),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () async {
            widget.onPressed();
            await Future.delayed(const Duration(milliseconds: 150));
            if (context.mounted) {
              _showSettingsConfirmDialog(context, SettingsConfirmType.apply);
            }
          },
          child: SizedBox(
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //* Button background
                  AnimatedContainer(
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    color: bgColor,
                  ),
                  //* Top pattern strip
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 10,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: animDuration,
                      curve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        AppAssets.patternTinyDots,
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                          AppColors.primaryDark.withValues(alpha: 0.60),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  //* Bottom pattern strip (no flip — decorative consistency)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 10,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: animDuration,
                      curve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        AppAssets.patternTinyDots,
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                          AppColors.primaryDark.withValues(alpha: 0.60),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  //* Label always on top
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.settingsApply,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.bodySBold.copyWith(
                            color: AppColors.lightSurfaceCard,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
