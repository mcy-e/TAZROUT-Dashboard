//? Scrollable table of AI decision log entries.
//? Filter tabs: All / Irrigation / Alerts / Advice.
//? Each row: ID | Date | Type badge | Details.
// TODO :: Wire to MQTT topic: tazrout/ai/decisions

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../widgets/common/empty_state_widget.dart';

//& DecisionLogsCard Widget
class DecisionLogsCard extends StatefulWidget {
  //* StatefulWidget — displays filtered AI decision logs
  const DecisionLogsCard({super.key});

  @override
  State<DecisionLogsCard> createState() => _DecisionLogsCardState();
}

class _DecisionLogsCardState extends State<DecisionLogsCard> {
  String _selectedFilter = 'All';

  static const List<Map<String, String>> _allLogs = [
    {
      'id': 'DEC-2024-001',
      'date': 'Oct 15, 2024',
      'type': 'IRRIGATION',
      'details': 'Watered Zones A, B (20 mins)',
    },
    {
      'id': 'WRN-2024-089',
      'date': 'Oct 14, 2024',
      'type': 'ALERT',
      'details': 'High temp variance detected in Zone C',
    },
    {
      'id': 'ADV-2024-012',
      'date': 'Oct 14, 2024',
      'type': 'ADVICE',
      'details': 'Optimal time to check NPK levels',
    },
    {
      'id': 'DEC-2024-002',
      'date': 'Oct 13, 2024',
      'type': 'IRRIGATION',
      'details': 'Watered Zone F (15 mins)',
    },
    {
      'id': 'ERR-2024-005',
      'date': 'Oct 12, 2024',
      'type': 'CRITICAL',
      'details': 'Valve Failure detected in Zone B',
    },
  ];

  List<Map<String, String>> get _filteredLogs {
    if (_selectedFilter == 'All') return _allLogs;
    //* Map button label to type value
    final map = {
      'Irrigation': 'IRRIGATION',
      'Alerts': 'ALERT',
      'Advice': 'ADVICE',
    };
    final target = map[_selectedFilter];
    if (target == null) return _allLogs;
    return _allLogs.where((log) => log['type'] == target).toList();
  }

  @override
  Widget build(BuildContext context) {
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
            //* Header Row
            Row(
              children: [
                Text(
                  'Decision Logs',
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const Spacer(),
                _FilterTabs(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //* Table Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('ID', style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('DATE', style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('TYPE', style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('DETAILS', style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText)),
                  ),
                ],
              ),
            ),
            Divider(color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider, height: 1),
            //* Scrollable Table Body
            Expanded(
              child: _filteredLogs.isEmpty
                  ? const EmptyStateWidget()
                  : ListView.builder(
                      itemCount: _filteredLogs.length,
                      itemBuilder: (context, index) {
                        return _DecisionLogRow(log: _filteredLogs[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//& _FilterTabs Widget
class _FilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _FilterTabs({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Irrigation', 'Alerts', 'Advice'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => onFilterChanged(filter),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 32),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: AppTypography.captionMedium.copyWith(
                      color: isSelected
                          ? (isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText)
                          : (isDark ? AppColors.darkMutedText : AppColors.lightMutedText),
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

//& _DecisionLogRow Widget
class _DecisionLogRow extends StatefulWidget {
  final Map<String, String> log;

  const _DecisionLogRow({required this.log});

  @override
  State<_DecisionLogRow> createState() => _DecisionLogRowState();
}

class _DecisionLogRowState extends State<_DecisionLogRow> {
  bool _isHovered = false;

  Color _typeColor(String type) {
    switch (type) {
      case 'IRRIGATION':
        return AppColors.primary;
      case 'ALERT':
        return AppColors.warningSolid;
      case 'ADVICE':
        return AppColors.infoSolid;
      default:
        return AppColors.errorSolid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final id = widget.log['id'] ?? '';
    final date = widget.log['date'] ?? '';
    final type = widget.log['type'] ?? '';
    final details = widget.log['details'] ?? '';
    final typeColor = _typeColor(type);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
              : (isDark
                  ? AppColors.darkHoverSurface.withValues(alpha: 0.0)
                  : AppColors.lightElevatedCard.withValues(alpha: 0.0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            //* flex 2: ID
            Expanded(
              flex: 2,
              child: Text(
                id,
                style: AppTypography.captionMedium.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
            //* flex 2: Date
            Expanded(
              flex: 2,
              child: Text(
                date,
                style: AppTypography.captionMedium.copyWith(
                  color: AppColors.darkMutedText,
                ),
              ),
            ),
            //* flex 2: DecisionTypeBadge
            Expanded(
              flex: 2,
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: AppTypography.overlineXS.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //* flex 3: Details
            Expanded(
              flex: 3,
              child: Text(
                details,
                style: AppTypography.captionMedium.copyWith(
                  color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
