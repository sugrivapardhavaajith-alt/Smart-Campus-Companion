import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Campusly Branded Logo Widget demonstrating Image asset usage and modern styling
class CampuslyLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const CampuslyLogoWidget({
    super.key,
    this.size = 54,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Offline PNG Asset demonstration
              Image.asset(
                'assets/images/campusly_logo.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 28,
                  );
                },
              ),
              // Crisp overlay icon
              Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: size * 0.55,
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Campusly',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size * 0.44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Smart Campus Companion',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
