import 'package:flutter/material.dart';

/// Animation configurations for consistent motion throughout the app
///
/// This file defines standard animation durations and curves to ensure
/// smooth and consistent transitions across all UI elements.
class AppAnimations {
  // Prevent instantiation
  AppAnimations._();

  /// Animation durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  /// Animation curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounce = Curves.easeOutBack;
  static const Curve elastic = Curves.elasticOut;

  /// Fade transition builder
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Scale transition builder
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
    Alignment alignment = Alignment.center,
  }) {
    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: child,
    );
  }

  /// Slide transition builder
  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(0.0, 0.1),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: easeInOut,
      )),
      child: child,
    );
  }

  /// Combined fade and slide transition
  static Widget fadeSlideTransition({
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(0.0, 0.1),
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: easeInOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Staggered animation helper
  static Animation<double> createStaggeredAnimation({
    required AnimationController controller,
    required double delay,
    Curve curve = easeInOut,
  }) {
    return CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        1.0,
        curve: curve,
      ),
    );
  }
}
