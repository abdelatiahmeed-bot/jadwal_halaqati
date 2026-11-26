import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Unified Motion & Animation System for ATHAR
class AppMotion {
  // Durations (200 - 400ms recommended for premium mobile UX)
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration quick = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration deliberate = Duration(milliseconds: 500);

  // Curves
  static const Curve standard = Curves.easeOutCubic;
  static const Curve entrance = Curves.easeOutQuart;
  static const Curve exit = Curves.easeInCubic;
  static const Curve smooth = Curves.easeInOutCubic;

  /// Check if the user has requested reduced motion in Android accessibility settings
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }
}

/// Interactive button / card wrapper with smooth scale & haptic feedback on touch
class AppPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final HitTestBehavior behavior;

  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 120),
    this.curve = AppMotion.standard,
    this.enableHaptic = true,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.prefersReducedMotion(context)) {
      return GestureDetector(
        behavior: widget.behavior,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: widget.child,
      );
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Animated numeric counter for points, counts, badges, and statistics
class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.curve = AppMotion.smooth,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    if (AppMotion.prefersReducedMotion(context)) {
      return Text('$prefix$value$suffix', style: style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, animatedVal, child) {
        return Text(
          '$prefix${animatedVal.round()}$suffix',
          style: style,
        );
      },
    );
  }
}

/// Shimmer effect placeholder for skeleton loading
class AppShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBase = widget.baseColor ??
        (isDark ? Colors.grey.shade800 : Colors.grey.shade300);
    final defaultHighlight = widget.highlightColor ??
        (isDark ? Colors.grey.shade700 : Colors.grey.shade100);

    if (AppMotion.prefersReducedMotion(context)) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: defaultBase,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                defaultBase,
                defaultHighlight,
                defaultBase,
              ],
              stops: [
                (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                _shimmerController.value,
                (_shimmerController.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
