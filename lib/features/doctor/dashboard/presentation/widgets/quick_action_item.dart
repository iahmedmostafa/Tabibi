import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class QuickActionItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const QuickActionItem({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<QuickActionItem>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.94);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [theme.cardColor, theme.cardColor]
                    : widget.gradientColors,
              ),
              border: Border.all(
                color: isDark
                    ? AppColors.grey800
                    : AppColors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.iconColor.withValues(alpha: isDark ? 0.15 : 0.10),
                  blurRadius: isDark ? 18 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -16,
                  top: -14,
                  child: Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(isDark ? 0.04 : 0.18),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -24,
                  child: Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(isDark ? 0.03 : 0.12),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor.withOpacity(isDark ? 0.25 : 0.9),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(widget.icon, color: widget.iconColor, size: 24.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.grey300 : AppColors.grey900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
