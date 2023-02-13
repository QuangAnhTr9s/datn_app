import 'package:flutter/material.dart';

class MyCircLeProgress extends CustomPainter {
  final Gradient gradient = const LinearGradient(
    colors: [
      Colors.yellow,
      Color(0xffee0342),
      Color(0xffec0d49),
      Color(0xFFE0258E),
      Color(0xFFE337A8)],
  );
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..strokeWidth = 12 //độ dày của progress
    ..style = PaintingStyle.stroke
      //vẽ một dãi màu
      ..shader = gradient.createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: 150));

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 150, paint);
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}