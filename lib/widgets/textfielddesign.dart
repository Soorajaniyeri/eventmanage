import 'package:flutter/material.dart';

class TextFieldDesign extends StatelessWidget {
 final TextEditingController controller;
 final TextInputType inputType ;
final  String hintText;
 final Widget? suffixIcon;
 final Color? brdrClr;
final bool secure;
  // String? Function(String?)? validator;



  const TextFieldDesign(

      {super.key,
        required this.hintText,
        this.suffixIcon,
        required this.controller,
        this.inputType = TextInputType.text,
        this.brdrClr, this.secure = false
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          border: Border.all(
            color: brdrClr??const Color(0xFFE8ECF4),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: TextFormField(
            obscureText: secure,
            keyboardType: inputType,

            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF8391A1),
                ),
                suffixIcon: suffixIcon),
          ),
        ),
      ),
    );
  }
}
