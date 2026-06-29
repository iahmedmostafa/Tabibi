import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A custom GoRouter transition page that applies a smooth Fade + Slide-Up animation.
class FadeSlideTransitionPage<T> extends CustomTransitionPage<T> {
  FadeSlideTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Subtle 6% slide up
            const double slideOffset = 0.06;

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, slideOffset),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 240),
        );
}

/// A standard Flutter PageRouteBuilder that applies a smooth Fade + Slide-Up animation.
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const double slideOffset = 0.06;

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, slideOffset),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 240),
        );
}

/// A custom [GoRoute] that automatically uses [FadeSlideTransitionPage]
/// for its page transitions instead of the default platform transitions.
class AppGoRoute extends GoRoute {
  AppGoRoute({
    required super.path,
    super.name,
    Widget Function(BuildContext, GoRouterState)? builder,
    super.routes,
    super.redirect,
    super.parentNavigatorKey,
  }) : super(
          pageBuilder: (context, state) {
            if (builder != null) {
              return FadeSlideTransitionPage(
                key: state.pageKey,
                name: state.name,
                arguments: state.extra,
                child: builder(context, state),
              );
            }
            return const NoTransitionPage(child: SizedBox.shrink());
          },
        );
}
