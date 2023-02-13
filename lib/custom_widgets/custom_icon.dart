
import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  const MyIcon({
    super.key, required this.iconData, required this.color,
  });
  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(50)),
        child: Center(child: Icon(iconData, size: 25, color: color,)));
  }
}