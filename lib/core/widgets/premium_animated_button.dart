import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';

class PremiumAnimatedButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const PremiumAnimatedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.gradientColors,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
    this.padding,
  });

  @override
  State<PremiumAnimatedButton> createState() => _PremiumAnimatedButtonState();
}

class _PremiumAnimatedButtonState extends State<PremiumAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.08, // Scales down by up to 8% on press
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ?? [
      AppColors.primary,
      const Color(0xFF0152CC), // Premium deep blue
    ];

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: [
              // Premium glowing shadow using primary color
              BoxShadow(
                color: colors.first.withOpacity(0.35),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              // Subtle inner-like highlight at the top border
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: -1,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: widget.iconSize ?? 15.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize ?? 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
