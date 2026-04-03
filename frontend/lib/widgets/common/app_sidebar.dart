//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tazrout_dashboard/core/localization/l10n/app_localizations.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/preferences_provider.dart';

//& NavItem Model
class _NavItem {
  final String label;
  final String route;
  final String darkIdle;
  final String darkHover;
  final String darkActive;
  final String lightIdle;
  final String lightHover;
  final String lightActive;
  final bool isEmergency;

  const _NavItem({
    required this.label,
    required this.route,
    required this.darkIdle,
    required this.darkHover,
    required this.darkActive,
    required this.lightIdle,
    required this.lightHover,
    required this.lightActive,
    this.isEmergency = false,
  });
}

//& AppSidebar Widget
class AppSidebar extends ConsumerStatefulWidget {
  //* Constructor for AppSidebar
  const AppSidebar({super.key});

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar> {
  //* Returns nav items with localized labels
  List<_NavItem> _buildNavItems(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      _NavItem(
        label: l.navHome,
        route: '/',
        darkIdle: AppAssets.darkIconHomeI,
        darkHover: AppAssets.darkIconHomeH,
        darkActive: AppAssets.darkIconHomeActive,
        lightIdle: AppAssets.lightIconHomeI,
        lightHover: AppAssets.lightIconHomeH,
        lightActive: AppAssets.lightIconHomeActive,
      ),
      _NavItem(
        label: l.navZones,
        route: '/zones',
        darkIdle: AppAssets.darkIconZoneI,
        darkHover: AppAssets.darkIconZoneH,
        darkActive: AppAssets.darkIconZonesActive,
        lightIdle: AppAssets.lightIconZoneI,
        lightHover: AppAssets.lightIconZoneH,
        lightActive: AppAssets.lightIconZonesActive,
      ),
      _NavItem(
        label: l.navAnalytics,
        route: '/analytics',
        darkIdle: AppAssets.darkIconAnalyticsI,
        darkHover: AppAssets.darkIconAnalyticsH,
        darkActive: AppAssets.darkIconAnalyticsActive,
        lightIdle: AppAssets.lightIconAnalyticsI,
        lightHover: AppAssets.lightIconAnalyticsH,
        lightActive: AppAssets.lightIconAnalyticsActive,
      ),
      _NavItem(
        label: l.navEmergency,
        route: '/emergency',
        darkIdle: AppAssets.darkIconEmergencyI,
        darkHover: AppAssets.darkIconEmergencyH,
        darkActive: AppAssets.darkIconEmergencyActive,
        lightIdle: AppAssets.lightIconEmergencyI,
        lightHover: AppAssets.lightIconEmergencyH,
        lightActive: AppAssets.lightIconEmergencyActive,
        isEmergency: true,
      ),
      _NavItem(
        label: l.navSettings,
        route: '/settings',
        darkIdle: AppAssets.darkIconSettingI,
        darkHover: AppAssets.darkIconSettingH,
        darkActive: AppAssets.darkIconSettingsActive,
        lightIdle: AppAssets.lightIconSettingI,
        lightHover: AppAssets.lightIconSettingH,
        lightActive: AppAssets.lightIconSettingsActive,
      ),
      _NavItem(
        label: l.navHelp,
        route: '/help',
        darkIdle: AppAssets.darkIconHelpI,
        darkHover: AppAssets.darkIconHelpH,
        darkActive: AppAssets.darkIconHelpActive,
        lightIdle: AppAssets.lightIconHelpI,
        lightHover: AppAssets.lightIconHelpH,
        lightActive: AppAssets.lightIconHelpActive,
      ),
      _NavItem(
        label: l.navUserManual,
        route: '/manual',
        darkIdle: AppAssets.darkIconUserManualI,
        darkHover: AppAssets.darkIconUserManualH,
        darkActive: AppAssets.darkIconUserManualActive,
        lightIdle: AppAssets.lightIconUserManualI,
        lightHover: AppAssets.lightIconUserManualH,
        lightActive: AppAssets.lightIconUserManualActive,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //* Watch sidebar expansion state
    final isExpanded = ref.watch(sidebarExpandedProvider);
    //* Watch emergency alert state
    final hasEmergency = ref.watch(hasEmergencyAlertProvider);
    //* Get current route
    final currentRoute = GoRouterState.of(context).uri.toString();
    //* Theme state
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final animDuration = ref.watch(preferencesProvider).animDuration;

    //* Localized navigation items
    final navItems = _buildNavItems(context);

    return ClipRect(
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: animDuration,
        curve: Curves.easeInOut,
        width: isExpanded ? 220.0 : 68.0,
        color: isDark ? AppColors.darkSidebar : AppColors.lightSurfaceCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SidebarHeader(
              isExpanded: isExpanded,
              isDark: isDark,
              animDuration: animDuration,
              onToggle: () {
                ref.read(sidebarExpandedProvider.notifier).state = !isExpanded;
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: navItems.map((item) {
                  return _SidebarNavItem(
                    item: item,
                    isExpanded: isExpanded,
                    isActive: currentRoute == item.route,
                    hasAlert: hasEmergency,
                    isDark: isDark,
                    animDuration: animDuration,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//& _SidebarHeader Widget
class _SidebarHeader extends StatelessWidget {
  final bool isExpanded;
  final bool isDark;
  final Duration animDuration;
  final VoidCallback onToggle;

  const _SidebarHeader({
    required this.isExpanded,
    required this.isDark,
    required this.animDuration,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 64,
        child: isExpanded
            ? OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 12),
                    //* Hamburger — LEFT side
                    _HamburgerButton(
                      isDark: isDark,
                      animDuration: animDuration,
                      onTap: onToggle,
                    ),
                    const SizedBox(width: 12),
                    //* Logo — RIGHT side (inside AnimatedOpacity)
                    AnimatedOpacity(
                      opacity: isExpanded ? 1.0 : 0.0,
                      duration: animDuration,
                      child: _SidebarLogo(
                        isDark: isDark,
                        isExpanded: isExpanded,
                        animDuration: animDuration,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              )
            : Center(
                child: _HamburgerButton(
                  isDark: isDark,
                  animDuration: animDuration,
                  onTap: onToggle,
                ),
              ),
      ),
    );
  }
}

//& _SidebarLogo Widget
class _SidebarLogo extends StatefulWidget {
  final bool isDark;
  final bool isExpanded;
  final Duration animDuration;

  const _SidebarLogo({
    required this.isDark,
    required this.isExpanded,
    required this.animDuration,
  });

  @override
  State<_SidebarLogo> createState() => _SidebarLogoState();
}

class _SidebarLogoState extends State<_SidebarLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      //* Subtle scale up on hover — makes it feel responsive
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: widget.animDuration,
        curve: Curves.easeInOut,
        //* Fixed size container prevents resize during crossfade
        child: SizedBox(
          height: 36,
          child: AnimatedCrossFade(
            duration: widget.animDuration,
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            crossFadeState: _isHovered
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            //* Default state logo
            firstChild: SvgPicture.asset(
              widget.isExpanded
                  ? (widget.isDark ? AppAssets.logoDarkDefault : AppAssets.logoLightDefault)
                  : (widget.isDark ? AppAssets.logoDarkIconDefault : AppAssets.logoLightIconDefault),
              height: 36,
              fit: BoxFit.contain,
            ),
            //* Hover state logo
            secondChild: SvgPicture.asset(
              widget.isExpanded
                  ? (widget.isDark ? AppAssets.logoDarkHover : AppAssets.logoLightHover)
                  : (widget.isDark ? AppAssets.logoDarkIconHover : AppAssets.logoLightIconHover),
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

//& _HamburgerButton Widget
class _HamburgerButton extends StatefulWidget {
  final bool isDark;
  final Duration animDuration;
  final VoidCallback onTap;

  const _HamburgerButton({
    required this.isDark,
    required this.animDuration,
    required this.onTap,
  });

  @override
  State<_HamburgerButton> createState() => _HamburgerButtonState();
}

class _HamburgerButtonState extends State<_HamburgerButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: widget.animDuration,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.darkHoverSurface.withValues(alpha: 0.5)
                : AppColors.lightSurfaceCard.withValues(alpha: 0.0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgPicture.asset(
              widget.isDark ? AppAssets.darkIconSideMenu : AppAssets.lightIconSideMenu,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}

//& _SidebarNavItem Widget
class _SidebarNavItem extends StatefulWidget {
  final _NavItem item;
  final bool isExpanded;
  final bool isActive;
  final bool hasAlert;
  final bool isDark;
  final Duration animDuration;

  const _SidebarNavItem({
    required this.item,
    required this.isExpanded,
    required this.isActive,
    required this.hasAlert,
    required this.isDark,
    required this.animDuration,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  String _resolveIcon(bool isActive, bool isHovered, bool isDark, _NavItem item) {
    if (isDark) {
      if (isActive) return item.darkActive;
      if (isHovered) return item.darkHover;
      return item.darkIdle;
    } else {
      if (isActive) return item.lightActive;
      if (isHovered) return item.lightHover;
      return item.lightIdle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: widget.isExpanded
              ? //* Expanded hover pill with pattern overlay
                Stack(
                  children: [
                    //* Base animated color background
                    AnimatedContainer(
                      duration: widget.animDuration,
                      curve: Curves.easeInOut,
                      height: 44,
                      decoration: BoxDecoration(
                        //* Use explicit transparent to avoid interpolation flash
                        color: widget.isActive
                            ? (widget.item.isEmergency
                                ? const Color(0x1AE94E31)
                                : AppColors.selectedSidebarBg)
                            : _isHovered
                                ? (widget.isDark
                                    ? AppColors.darkHoverSurface.withValues(alpha: 0.6)
                                    : AppColors.lightElevatedCard)
                                : (widget.isDark
                                    ? AppColors.darkHoverSurface.withValues(alpha: 0.0)
                                    : AppColors.lightElevatedCard.withValues(alpha: 0.0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    //* Pattern overlay — subtle, fixed to right edge (right: 2)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 2,
                      child: AnimatedOpacity(
                        duration: widget.animDuration,
                        curve: Curves.easeInOut,
                        opacity: _isHovered && !widget.isActive ? 1.0 : 0.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SvgPicture.asset(
                            widget.isDark
                                ? AppAssets.navHoverBgDark
                                : AppAssets.navHoverBgLight,
                            height: 44,
                            //* fit: contain keeps pattern from overwhelming the text
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    //* Content row on top
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //* Icon — always exists on left
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                _resolveIcon(widget.isActive, _isHovered, widget.isDark, widget.item),
                                fit: BoxFit.contain,
                              ),
                            ),
                            //* Spacer + Label if expanded
                            if (widget.isExpanded) ...[
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  widget.item.label,
                                  textAlign: isArabic(context) ? TextAlign.right : TextAlign.start,
                                  textDirection: textDirectionForUiLocale(context),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: widget.isActive
                                      ? AppTypography.bodySMedium.copyWith(
                                          color: widget.item.isEmergency
                                              ? AppColors.errorSolid
                                              : AppColors.primaryLight)
                                      : AppTypography.bodySMedium.copyWith(
                                          color: widget.isDark
                                              ? AppColors.darkMutedText
                                              : AppColors.lightBodyText),
                                ),
                              ),
                              //* Emergency alert dot
                              if (widget.item.isEmergency && widget.hasAlert) ...[
                                const SizedBox(width: 4),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.errorSolid,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : //* Collapsed hover — perfectly centered square pill
                SizedBox(
                  width: 68,
                  height: 48,
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? (widget.item.isEmergency
                                ? const Color(0x1AE94E31)
                                : AppColors.selectedSidebarBg)
                            : _isHovered
                                ? (widget.isDark
                                    ? AppColors.darkHoverSurface.withValues(alpha: 0.6)
                                    : AppColors.lightElevatedCard)
                                : AppColors.lightSurfaceCard.withValues(alpha: 0.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            _resolveIcon(widget.isActive, _isHovered, widget.isDark, widget.item),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
