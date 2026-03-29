//? macOS-style window title bar decoration.
//? Three traffic-light dots (red/amber/green)  visual only, no actions.
//? Filename tab centered in the bar.

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& MacWindowChrome Widget
class MacWindowChrome extends StatelessWidget {
  final String fileName;

  //* Provides macOS style chrome for document containers
  const MacWindowChrome({
    super.key,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Container full width height 40px
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        //* bg: AppColors.darkBase (dark) / AppColors.lightElevatedCard (light)
        color: isDark ? AppColors.darkBase : AppColors.lightElevatedCard,
        //* borderRadius top-only: 12px
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          //* Traffic light dots
          Row(
            children: const [
              _Dot(color: Color(0xFFFF5F57)), // red
              SizedBox(width: 6),
              _Dot(color: Color(0xFFFFBD2E)), // amber
              SizedBox(width: 6),
              _Dot(color: Color(0xFF28C840)), // green
            ],
          ),
          //* Filename tab centered in the bar
          Expanded(
            child: Center(
              child: Text(
                fileName,
                style: AppTypography.captionMedium.copyWith(
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
              ),
            ),
          ),
          //* Balancing spacer for the leading dots
          const SizedBox(width: 52),
        ],
      ),
    );
  }
}

//& _Dot Widget
class _Dot extends StatelessWidget {
  final Color color;

  //* Circular traffic light indicator
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    //* Container 12x12 circle with given color
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
