import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  late String placeHolder ;
  late TextEditingController? textEditingController;
  late bool obscureText = false;
  late String? errorText;

   MyTextField({super.key, required  this.placeHolder,
    required  this.textEditingController,
    required  this.obscureText,
    required this.errorText,});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
      obscureText: widget.obscureText,
      cursorColor: Colors.grey,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        errorText: widget.errorText,
        //để null thì khi ko bị lỗi, textfield ko bị bôi đỏ viền
        hintText: widget.placeHolder,
        hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

}
