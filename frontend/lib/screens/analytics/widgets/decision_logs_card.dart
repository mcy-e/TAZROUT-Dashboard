//? Scrollable table of AI decision log entries.
//? Filter tabs: All / Irrigation / Alerts / Advice.
//? Each row: ID | Date | Type badge | Details.
//? Wired to MQTT topic: tazrout/ai/decisions

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../widgets/common/empty_state_widget.dart';
import '../../../../providers/ai_decision_provider.dart';
import '../../../../models/ai_decision_model.dart';
import 'package:intl/intl.dart';

//& DecisionLogsCard Widget
class DecisionLogsCard extends ConsumerStatefulWidget {
  //* StatefulWidget — displays filtered AI decision logs
  const DecisionLogsCard({super.key});

  @override
  ConsumerState<DecisionLogsCard> createState() => _DecisionLogsCardState();
}

class _DecisionLogsCardState extends ConsumerState<DecisionLogsCard> {
  //* Internal filter keys (stable English) — labels come from l10n
  String _selectedFilterKey = 'all';
  List<AiDecisionModel> _getFilteredLogs(List<AiDecisionModel> allLogs) {
    if (_selectedFilterKey == 'all') return allLogs;
    final target = switch (_selectedFilterKey) {
      'irrigation' => DecisionType.irrigation,
      'alerts' => DecisionType.alert,
      'advice' => DecisionType.advice,
      _ => null,
    };
    if (target == null) return allLogs;
    return allLogs.where((log) => log.type == target).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final logs = ref.watch(aiDecisionProvider).log;
    final filteredLogs = _getFilteredLogs(logs);

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
                  l10n.decisionLogsTitle,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const Spacer(),
                _FilterTabs(
                  selectedFilterKey: _selectedFilterKey,
                  onFilterChanged: (key) => setState(() => _selectedFilterKey = key),
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
                    child: Text(
                      l10n.columnId,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      l10n.columnDate,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      l10n.columnType,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      l10n.columnDetails,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.overlineXS.copyWith(color: AppColors.darkMutedText),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider, height: 1),
            //* Scrollable Table Body
            Expanded(
              child: filteredLogs.isEmpty
                  ? EmptyStateWidget(message: l10n.emptyStateNoData)
                  : ListView.builder(
                      itemCount: filteredLogs.length,
                      itemBuilder: (context, index) {
                        return _DecisionLogRow(log: filteredLogs[index]);
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
  final String selectedFilterKey;
  final ValueChanged<String> onFilterChanged;

  const _FilterTabs({
    required this.selectedFilterKey,
    required this.onFilterChanged,
  });

  static const List<String> _keys = ['all', 'irrigation', 'alerts', 'advice'];

  String _labelForKey(String key, AppLocalizations l10n) {
    return switch (key) {
      'all' => l10n.filterAll,
      'irrigation' => l10n.filterIrrigation,
      'alerts' => l10n.filterAlerts,
      'advice' => l10n.filterAdvice,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _keys.map((key) {
        final isSelected = selectedFilterKey == key;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () => onFilterChanged(key),
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
                    _labelForKey(key, l10n),
                    textDirection: textDirectionForUiLocale(context),
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
    final id = widget.log.decisionId;
    final shortId = id.length > 8 ? '${id.substring(0, 8)}…' : id;
    final date = DateFormat('MMM dd, yyyy').format(widget.log.decisionDate);
    final type = widget.log.label;
    final details = widget.log.description;
    final typeColor = widget.log.color;

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
                shortId,
                textDirection: textDirectionForUiLocale(context),
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
                textDirection: textDirectionForUiLocale(context),
                style: AppTypography.captionMedium.copyWith(
                  color: AppColors.darkMutedText,
                ),
              ),
            ),
            //* flex 2: DecisionTypeBadge — DATA type string from MQTT
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
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.overlineXS.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            //* flex 3: Details — DATA
            Expanded(
              flex: 3,
              child: Text(
                details,
                textDirection: textDirectionForUiLocale(context),
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
