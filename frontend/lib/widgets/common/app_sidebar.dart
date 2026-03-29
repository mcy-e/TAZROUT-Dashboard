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

    //* Animated sidebar container
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isExpanded ? 220 : 68,
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSidebar
          : AppColors.lightSurfaceCard,
      child: Column(
        children: [
          //* Sidebar Header: Logo + Hamburger
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isExpanded
                ? Row(
                    children: [
                      //* Logo SVG — expanded state shows full logo with wordmark
                      SvgPicture.asset(
                        isDark ? AppAssets.logoDarkDefault : AppAssets.logoLightDefault,
                        height: 28,
                      ),
                      const Spacer(),
                      //* Hamburger toggle button
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => ref.read(sidebarExpandedProvider.notifier).state = false,
                      ),
                    ],
                  )
                : //* Collapsed header: icon only, centered
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => ref.read(sidebarExpandedProvider.notifier).state = true,
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
    );
  }
}

//& _SidebarNavItem Class
class _SidebarNavItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Color logic for active/inactive states
    final color = isActive
        ? AppColors.primaryDark
        : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText);

    //* Build item content
    Widget content = Container(
      height: 48,
      decoration: BoxDecoration(
        color: isActive ? AppColors.selectedSidebarBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          //* Icon with optional badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: color,
              ),
              if (showEmergencyBadge)
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
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                item.label,
                style: TextStyle(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      ),
    );

    //* Wrap in Tooltip when collapsed
    if (!isExpanded) {
      content = Tooltip(
        message: item.label,
        preferBelow: false,
        margin: const EdgeInsets.only(left: 70),
        child: content,
      );
    }

    //* Make it interactive
    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }
}
