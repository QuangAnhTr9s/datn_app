
import 'package:flutter/material.dart';

class MyBoxButton extends StatelessWidget {

   const MyBoxButton({
    super.key,
    required this.isClicked, required this.name, this.colorOn, this.colorOff,
     required this.height, required this.width, required this.iconData, required this.onTap,
  });
  final double height;
  final double width;
  final bool isClicked;
  final String name;
  final Color? colorOn;
  final Color? colorOff;
  final IconData iconData;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        height: height,
        width: width,
        decoration: BoxDecoration( color: isClicked == true ? colorOn : colorOff, borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //icon
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(50)),
              child: Icon(iconData),
            ),
            const SizedBox(height: 15,),
            //text name
            Text(name, style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),
            const SizedBox(height: 5,),
            //text ON/OFF
            Text(isClicked == true ? 'ON' : 'OFF', style: const TextStyle(fontSize: 22, color: Colors.black),)
          ],
        ),
      ),
    );
  }
}