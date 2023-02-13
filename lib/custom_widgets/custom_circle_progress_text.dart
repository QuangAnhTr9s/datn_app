import 'dart:math';

import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final String bottomText;
  final TextStyle bottomTextStyle;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  const CustomCircularProgressIndicator({super.key,
    required this.progress,
    required this.bottomText,
    required this.bottomTextStyle,
    this.strokeWidth = 10,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomCircularProgressPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
      ),
      child: Center(
        child: Text(
          bottomText,
          style: bottomTextStyle,
        ),
      ),
    );
  }
}

class _CustomCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  _CustomCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = (size.width) / 2;
    final double angle = 2 * pi * progress;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, -pi / 2, 2 * pi, false, backgroundPaint);
    canvas.drawArc(rect, -pi / 2, angle, false, progressPaint);
  }

  @override
  bool shouldRepaint(_CustomCircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.progressColor != progressColor ||
          oldDelegate.backgroundColor != backgroundColor;
}
