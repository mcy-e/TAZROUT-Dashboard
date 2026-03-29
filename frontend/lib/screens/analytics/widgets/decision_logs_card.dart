//? Scrollable table of AI decision log entries.
//? Filter tabs: All / Irrigation / Alerts / Advice.
//? Each row: ID | Date | Type badge | Details.
// TODO :: Wire to MQTT topic: tazrout/ai/decisions

//& Imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/ai_decision_model.dart';

//& DecisionLogsCard Widget
class DecisionLogsCard extends StatefulWidget {
  //* StatefulWidget — displays filtered AI decision logs
  const DecisionLogsCard({super.key});

  @override
  State<DecisionLogsCard> createState() => _DecisionLogsCardState();
}

class _DecisionLogsCardState extends State<DecisionLogsCard> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Static data — 5 rows
    // TODO :: Replace with real MQTT data from topic: tazrout/ai/decisions
    final List<AiDecisionModel> allLogs = [
      AiDecisionModel(
        decisionId: 'DEC-2024-001',
        decisionDate: DateTime(2024, 10, 15),
        type: DecisionType.irrigation,
        affectedZones: ['Zone A', 'Zone B'],
        description: 'Watered Zones A,B (20 mins)',
        notes: '',
        farmerAdvice: '',
      ),
      AiDecisionModel(
        decisionId: 'WRN-2024-089',
        decisionDate: DateTime(2024, 10, 14),
        type: DecisionType.alert,
        affectedZones: ['Zone C'],
        description: 'High temp variance in Zone C',
        notes: '',
        farmerAdvice: '',
      ),
      AiDecisionModel(
        decisionId: 'ADV-2024-012',
        decisionDate: DateTime(2024, 10, 14),
        type: DecisionType.advice,
        affectedZones: [],
        description: 'Optimal time to check NPK levels',
        notes: '',
        farmerAdvice: '',
      ),
      AiDecisionModel(
        decisionId: 'DEC-2024-002',
        decisionDate: DateTime(2024, 10, 13),
        type: DecisionType.irrigation,
        affectedZones: ['Zone F'],
        description: 'Watered Zone F (15 mins)',
        notes: '',
        farmerAdvice: '',
      ),
      AiDecisionModel(
        decisionId: 'ERR-2024-005',
        decisionDate: DateTime(2024, 10, 12),
        type: DecisionType.critical,
        affectedZones: ['Zone B'],
        description: 'Valve Failure in Zone B',
        notes: '',
        farmerAdvice: '',
      ),
    ];

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
              child: ListView.builder(
                itemCount: allLogs.length,
                itemBuilder: (context, index) {
                  return _DecisionLogRow(log: allLogs[index]);
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
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: AppTypography.captionMedium.copyWith(
                      color: isSelected
                          ? Colors.white
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
  final AiDecisionModel log;

  const _DecisionLogRow({required this.log});

  @override
  State<_DecisionLogRow> createState() => _DecisionLogRowState();
}

class _DecisionLogRowState extends State<_DecisionLogRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = DateFormat('MMM dd yyyy').format(widget.log.decisionDate);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            //* flex 2: ID
            Expanded(
              flex: 2,
              child: Text(
                widget.log.decisionId,
                style: AppTypography.captionMedium.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
            //* flex 2: Date
            Expanded(
              flex: 2,
              child: Text(
                dateStr,
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
                    color: widget.log.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.log.label,
                    style: AppTypography.overlineXS.copyWith(
                      color: widget.log.color,
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
                widget.log.description,
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
