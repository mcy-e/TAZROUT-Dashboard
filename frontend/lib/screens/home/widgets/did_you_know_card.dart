//? Rotating agricultural fact card.
//? Light bulb icon top-right. Label "DID YOU KNOW?" in overline style.
//? Highlighted percentage value in AppColors.primary bold.
// TODO :: Wire fact to MQTT topic: tazrout/dashboard/summary

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/locale_text_direction.dart';
import '../../../core/utils/app_logger.dart';

//& DidYouKnowCard
class DidYouKnowCard extends StatefulWidget {
  const DidYouKnowCard({super.key});

  @override
  State<DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<DidYouKnowCard> {
  bool _isHovered = false;
  int _currentIndex = 0;
  Timer? _timer;
  List<Map<String, dynamic>> _facts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacts();
  }

  Future<void> _loadFacts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/facts.json');
      final List<dynamic> parsed = jsonDecode(jsonString);
      
      if (!mounted) return;
      setState(() {
        _facts = parsed.map((e) => e as Map<String, dynamic>).toList();
        _isLoading = false;
      });

      if (_facts.isNotEmpty) {
        _timer = Timer.periodic(const Duration(seconds: 15), (_) {
          if (mounted) {
            setState(() => _currentIndex = (_currentIndex + 1) % _facts.length);
          }
        });
      }
    } catch (e, st) {
      AppLogger.error('HOME', 'Failed to load facts.json', e, st);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<TextSpan> _parseFactText(String text, bool isDark) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        // Bold part
        spans.add(TextSpan(
          text: parts[i],
          style: AppTypography.bodyMBold.copyWith(color: AppColors.primary),
        ));
      } else {
        // Regular part
        spans.add(TextSpan(
          text: parts[i],
        ));
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        margin: EdgeInsets.zero,
        child: SizedBox(height: 140, child: Center(child: CircularProgressIndicator())),
      );
    }
    
    if (_facts.isEmpty) {
      return const SizedBox.shrink(); // Hide completely if json is empty or failed
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final locale = l10n.localeName; // 'en', 'fr', or 'ar'
    
    // Fallback to English if language key is missing
    final factMap = _facts[_currentIndex];
    final currentFactText = factMap[locale] ?? factMap['en'] ?? '';

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [

            //* Background symbol — bottom center, fades in on hover
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: _isHovered ? 1.0 : 0.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SvgPicture.asset(
                      AppAssets.symbolUnity,
                      height: 55,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary.withValues(alpha: 0.12),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            //* Lightbulb icon — top right, clipped
            Positioned(
              top: -8,
              right: -8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 4),
                    child: SvgPicture.asset(
                      isDark
                          ? AppAssets.darkIconFactLamp
                          : AppAssets.lightIconFactLamp,
                      height: 18,
                    ),
                  ),
                ),
              ),
            ),
            //* Foreground content — full card, stays on top
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //* Header row: fertility sparkle on hover + label + lightbulb with circular bg
                  Row(
                    children: [
                      //* Fertility symbol — amber, always visible
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: SvgPicture.asset(
                          isDark
                              ? AppAssets.darkIconFactStar
                              : AppAssets.lightIconFactStar,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.series3Amber,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        l10n.didYouKnow,
                        style: AppTypography.overlineS.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  //* Fact text with quoted wrapper and bold percentage
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: RichText(
                      key: ValueKey(_currentIndex),
                      textDirection: textDirectionForUiLocale(context),
                      text: TextSpan(
                        style: AppTypography.bodySRegular.copyWith(
                          color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                          height: 1.5,
                        ),
                        children: _parseFactText(currentFactText, isDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
