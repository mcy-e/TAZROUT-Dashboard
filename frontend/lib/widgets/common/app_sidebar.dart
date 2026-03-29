//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/navigation_provider.dart';

//& NavItem Model
class _NavItem {
  final String label;
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final bool isEmergency;

  const _NavItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.activeIcon,
    this.isEmergency = false,
  });
}

//& AppSidebar Widget
class AppSidebar extends ConsumerWidget {
  //* Constructor for AppSidebar
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Watch sidebar expansion state
    final isExpanded = ref.watch(sidebarExpandedProvider);
    //* Watch emergency alert state
    final hasEmergency = ref.watch(hasEmergencyAlertProvider);
    //* Get current route
    final currentRoute = GoRouterState.of(context).uri.toString();
    //* Theme state
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Define navigation items
    final navItems = [
      _NavItem(
        label: 'Home',
        route: '/',
        icon: PhosphorIcons.house(),
        activeIcon: PhosphorIcons.house(PhosphorIconsStyle.fill),
      ),
      _NavItem(
        label: 'Zones',
        route: '/zones',
        icon: PhosphorIcons.selectionAll(),
        activeIcon: PhosphorIcons.selectionAll(PhosphorIconsStyle.fill),
      ),
      _NavItem(
        label: 'Analytics',
        route: '/analytics',
        icon: PhosphorIcons.chartBar(),
        activeIcon: PhosphorIcons.chartBar(PhosphorIconsStyle.fill),
      ),
      _NavItem(
        label: 'Emergency',
        route: '/emergency',
        icon: PhosphorIcons.warningCircle(),
        activeIcon: PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
        isEmergency: true,
      ),
      _NavItem(
        label: 'Settings',
        route: '/settings',
        icon: PhosphorIcons.gear(),
        activeIcon: PhosphorIcons.gear(PhosphorIconsStyle.fill),
      ),
      _NavItem(
        label: 'Help',
        route: '/help',
        icon: PhosphorIcons.question(),
        activeIcon: PhosphorIcons.question(PhosphorIconsStyle.fill),
      ),
      _NavItem(
        label: 'User Manual',
        route: '/manual',
        icon: PhosphorIcons.bookOpen(),
        activeIcon: PhosphorIcons.bookOpen(PhosphorIconsStyle.fill),
      ),
    ];

    //* Animated sidebar container wrapped in ClipRect to prevent overflow painting
    //* FIX 1: ClipRect eliminates overflow during collapse/expand transition
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        //* FIX 4: Hard constraints prevent sub-pixel width issues during animation
        constraints: BoxConstraints(
          minWidth: isExpanded ? 220 : 68,
          maxWidth: isExpanded ? 220 : 68,
        ),
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSidebar
            : AppColors.lightSurfaceCard,
        child: Column(
          children: [
            //* Sidebar Header: Logo + Toggle Button
            //* FIX 3: AnimatedSwitcher transitions between expanded and collapsed header
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isExpanded
                    ? Row(
                        key: const ValueKey('expanded'),
                        children: [
                          //* Full logo — expanded state
                          Flexible(
                            child: SvgPicture.asset(
                              isDark
                                  ? AppAssets.logoDarkDefault
                                  : AppAssets.logoLightDefault,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Spacer(),
                          //* Collapse button
                          IconButton(
                            onPressed: () => ref
                                .read(sidebarExpandedProvider.notifier)
                                .state = false,
                            icon: const Icon(Icons.chevron_left),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                                minWidth: 48, minHeight: 48),
                          ),
                        ],
                      )
                    : Row(
                        key: const ValueKey('collapsed'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //* Toggle button — collapsed state
                          IconButton(
                            onPressed: () => ref
                                .read(sidebarExpandedProvider.notifier)
                                .state = true,
                            icon: const Icon(Icons.chevron_right),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                                minWidth: 48, minHeight: 48),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            //* Navigation Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: navItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isActive = currentRoute == item.route;

                  return _SidebarNavItem(
                    item: item,
                    isExpanded: isExpanded,
                    isActive: isActive,
                    showEmergencyBadge: item.isEmergency && hasEmergency,
                  );
                },
              ),
            ),
            //* Bottom Spacer
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

//& _SidebarNavItem Class
class _SidebarNavItem extends StatefulWidget {
  final _NavItem item;
  final bool isExpanded;
  final bool isActive;
  final bool showEmergencyBadge;

  const _SidebarNavItem({
    required this.item,
    required this.isExpanded,
    required this.isActive,
    required this.showEmergencyBadge,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Color logic for active/inactive states
    final color = widget.isActive
        ? AppColors.primaryDark
        : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText);

    //* Build item content
    Widget itemContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 48,
      decoration: BoxDecoration(
        color: widget.isActive
            ? AppColors.selectedSidebarBg
            : (_isHovered
                ? (isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05))
                : Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      //* FIX 2: Row is constrained — label must never force overflow
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.isExpanded
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          //* Icon with optional badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.isActive ? widget.item.activeIcon : widget.item.icon,
                size: 22,
                color: color,
              ),
              if (widget.showEmergencyBadge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.errorSolid,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          //* Label (only when expanded)
          if (widget.isExpanded) ...[
            const SizedBox(width: 12),
            //* Flexible absorbs remaining space without overflow
            Flexible(
              child: Text(
                widget.item.label,
                style: TextStyle(
                  color: color,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ],
      ),
    );

    //* Wrap in Tooltip when collapsed
    if (!widget.isExpanded) {
      itemContent = Tooltip(
        message: widget.item.label,
        preferBelow: false,
        margin: const EdgeInsets.only(left: 70),
        child: itemContent,
      );
    }

    //* Dual input: MouseRegion for mouse hover, InkWell for touch press
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => context.go(widget.item.route),
        borderRadius: BorderRadius.circular(8),
        child: itemContent,
      ),
    );
  }
}
