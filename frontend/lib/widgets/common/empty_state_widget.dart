import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

//& EmptyStateWidget
class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({super.key, this.message = 'No data available'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Centered empty-state message
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.symbolBalance,
            height: 40,
            colorFilter: ColorFilter.mode(
              isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTypography.bodySRegular.copyWith(
              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
            ),
          ),
        ],
      ),
    );
  }
}

