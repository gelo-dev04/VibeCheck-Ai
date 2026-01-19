import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VibeSprite extends StatelessWidget {
  final String expression; // 'chill', 'chaotic', 'happy', 'calm'
  final Color color;
  final double size;

  const VibeSprite({
    super.key,
    required this.expression,
    required this.color,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 3D-ish Glow effect
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.1,
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),

          // Body
          CustomPaint(
                size: Size(size * 0.8, size * 0.8),
                painter: _SpritePainter(expression: expression, color: color),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(
                begin: -size * 0.05,
                end: size * 0.05,
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  final String expression;
  final Color color;

  _SpritePainter({required this.expression, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw Body
    if (expression == 'chaotic') {
      final path = Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width, size.height / 2)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(0, size.height / 2)
        ..close();
      canvas.drawPath(path, paint);
    } else {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(size.width / 2.5),
      );
      canvas.drawRRect(rect, paint);
    }

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    if (expression == 'chill') {
      // Slanted eyes
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.3,
            size.height * 0.45,
            size.width * 0.12,
            size.height * 0.04,
          ),
          const Radius.circular(2),
        ),
        eyePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.58,
            size.height * 0.45,
            size.width * 0.12,
            size.height * 0.04,
          ),
          const Radius.circular(2),
        ),
        eyePaint,
      );
    } else if (expression == 'chaotic') {
      // X eyes
      _drawX(
        canvas,
        Offset(size.width * 0.35, size.height * 0.5),
        size.width * 0.08,
        eyePaint,
      );
      _drawX(
        canvas,
        Offset(size.width * 0.65, size.height * 0.5),
        size.width * 0.08,
        eyePaint,
      );
    } else {
      // Circle eyes
      canvas.drawCircle(
        Offset(size.width * 0.35, size.height * 0.48),
        size.width * 0.04,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.65, size.height * 0.48),
        size.width * 0.04,
        eyePaint,
      );
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    if (expression == 'happy') {
      final mouthPath = Path()
        ..moveTo(size.width * 0.4, size.height * 0.65)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.75,
          size.width * 0.6,
          size.height * 0.65,
        );
      canvas.drawPath(mouthPath, mouthPaint);
    } else if (expression == 'chill') {
      canvas.drawLine(
        Offset(size.width * 0.42, size.height * 0.68),
        Offset(size.width * 0.58, size.height * 0.68),
        mouthPaint,
      );
    } else if (expression == 'calm') {
      final mouthPath = Path()
        ..moveTo(size.width * 0.42, size.height * 0.68)
        ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.65,
          size.width * 0.58,
          size.height * 0.68,
        );
      canvas.drawPath(mouthPath, mouthPaint);
    }
  }

  void _drawX(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawLine(
      center - Offset(size, size),
      center + Offset(size, size),
      paint..strokeWidth = 3,
    );
    canvas.drawLine(
      center - Offset(size, -size),
      center + Offset(size, -size),
      paint..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
