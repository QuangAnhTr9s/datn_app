
import 'package:flutter/cupertino.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
    required this.isClicked, required this.name, this.colorOn, this.colorOff,
  });

  final bool isClicked;
  final String name;
  final Color? colorOn;
  final Color? colorOff;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(color: isClicked == true ? colorOn : colorOff, borderRadius: BorderRadius.circular(50)),
      child: Image.asset(name, fit: BoxFit.fill,),
    );
  }
}