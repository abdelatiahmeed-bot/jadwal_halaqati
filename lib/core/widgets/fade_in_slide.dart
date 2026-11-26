import 'package:flutter/material.dart';

class FadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Duration delay;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 30.0,
    this.delay = Duration.zero,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offset / 100),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic)),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
