import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String hint;
  final bool obscure;
  final Icon? suffix;
  final TextEditingController controller;
  const TextFieldWidget(
      {super.key,
      required this.hint,
      this.suffix,
      required this.obscure,
      required this.controller});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: widget.controller,
          style: TextStyle(color: Colors.black),
          obscureText: widget.obscure,
          decoration: InputDecoration(
            suffixIcon: widget.suffix,
            hintText: widget.hint, // Set your hint text here
            hintStyle: TextStyle(
                color: Color.fromRGBO(200, 199, 199, 1), fontSize: 13),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(231, 232, 239, 1), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(231, 232, 239, 1), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(30),
          ],
        ),
      ),
    );
  }
}
