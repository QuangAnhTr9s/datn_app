import 'dart:math';

import 'package:flutter/material.dart';

class ProgressArc extends CustomPainter{
  final Gradient gradient = const LinearGradient(
    colors: [
      Colors.yellow,
      Color(0xffec7c0d),
      Color(0xFFE02535),
    ],
  );
  bool isBackground;
  double? arc;
  Color progressColor;
  ProgressArc(this.arc, this.progressColor, this.isBackground);
  @override
  void paint (Canvas canvas, Size size) {
    const rect = Rect.fromLTRB (0,0, 220, 220);
    const startAngle = - pi;
    final sweepAngle = arc ?? pi;
    const userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round ..color = progressColor
      ..style = PaintingStyle.stroke ..strokeWidth = 20;
    if(!isBackground) {
      paint.shader = gradient.createShader(rect);
    }
    canvas.drawArc (rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}