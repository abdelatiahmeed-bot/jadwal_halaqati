import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athar/core/theme/theme.dart';

enum NotificationType { success, warning, error, info }

class AppNotification {
  static OverlayEntry? _currentEntry;

  static void showSuccess(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title ?? 'تم بنجاح', type: NotificationType.success);
  }

  static void showError(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title ?? 'خطأ', type: NotificationType.error);
  }

  static void showWarning(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title ?? 'تنبيه', type: NotificationType.warning);
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title ?? 'إشعار', type: NotificationType.info);
  }

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _AnimatedNotificationToast(
        message: message,
        title: title,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _AnimatedNotificationToast extends StatefulWidget {
  final String message;
  final String? title;
  final NotificationType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AnimatedNotificationToast({
    required this.message,
    this.title,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_AnimatedNotificationToast> createState() => _AnimatedNotificationToastState();
}

class _AnimatedNotificationToastState extends State<_AnimatedNotificationToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    // Auto dismiss after 1 second duration
    _dismissTimer = Timer(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    _dismissTimer?.cancel();
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.completed) {
      await _controller.reverse();
    }
    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color _getPrimaryColor() {
    switch (widget.type) {
      case NotificationType.success:
        return const Color(0xFF1E6B38);
      case NotificationType.warning:
        return const Color(0xFFC58800);
      case NotificationType.error:
        return const Color(0xFFB3261E);
      case NotificationType.info:
        return IslamicTheme.oliveDeep;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case NotificationType.success:
        return Icons.check_circle_rounded;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.error:
        return Icons.error_outline_rounded;
      case NotificationType.info:
        return Icons.notifications_active_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor();

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: _dismiss,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    constraints: const BoxConstraints(maxWidth: 340),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFCF9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.20),
                          blurRadius: 26,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getIcon(), color: primaryColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.title != null) ...[
                                Text(
                                  widget.title!,
                                  style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                              ],
                              Text(
                                widget.message,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: const Color(0xFF2B3724),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
                          onPressed: _dismiss,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
