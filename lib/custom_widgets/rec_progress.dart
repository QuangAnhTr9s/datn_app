import 'package:flutter/material.dart';

class MyRectProgress extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5 //độ dày của progress
      ..style = PaintingStyle.stroke;
    const rect = Rect.fromLTRB (0,0, 200, 50);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}