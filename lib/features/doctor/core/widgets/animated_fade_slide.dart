import 'package:flutter/material.dart';

class AnimatedFadeSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int delayMilliseconds;

  const AnimatedFadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 24,
    this.delayMilliseconds = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
