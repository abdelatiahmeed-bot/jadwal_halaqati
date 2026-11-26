import 'dart:math';
import 'package:flutter/material.dart';

class IslamicPatternBackground extends StatelessWidget {
  const IslamicPatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Premium theme-aware gradient
    final gradient = isDark
        ? const RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF16251C), // Deep olive green center
              Color(0xFF0C120E), // Very dark near-black edges
            ],
          )
        : const RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFFF0F7F2), // Light mint green center
              Color(0xFFF9FBF9), // Soft white edges
            ],
          );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: CustomPaint(
        painter: _IslamicPatternPainter(
          color: Theme.of(context).colorScheme.primary.withValues(
            alpha: isDark ? 0.04 : 0.025,
          ),
        ),
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const double sizeGrid = 90.0;
    final int rows = (size.height / sizeGrid).ceil() + 1;
    final int cols = (size.width / sizeGrid).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double cx = c * sizeGrid;
        final double cy = r * sizeGrid;

        // Draw an 8-pointed Islamic Star
        _drawStar(canvas, paint, cx, cy, sizeGrid * 0.4);
        
        // Draw grid lines
        canvas.drawCircle(Offset(cx, cy), sizeGrid * 0.2, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double cx, double cy, double radius) {
    final path1 = Path();
    final path2 = Path();

    // Standard square rotated 45 deg
    path1.moveTo(cx + radius, cy);
    path1.lineTo(cx, cy + radius);
    path1.lineTo(cx - radius, cy);
    path1.lineTo(cx, cy - radius);
    path1.close();

    final double offset = radius / sqrt(2);
    path2.moveTo(cx + offset, cy + offset);
    path2.lineTo(cx - offset, cy + offset);
    path2.lineTo(cx - offset, cy - offset);
    path2.lineTo(cx + offset, cy - offset);
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
