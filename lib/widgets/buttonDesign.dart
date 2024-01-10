import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonDesign extends StatelessWidget {
  final void Function() onTap;
  final String buttonText;
  final Color bgClr;
  final double? margin;

  const ButtonDesign(
      {super.key,
      required this.buttonText,
      required this.onTap,
      this.bgClr = Colors.black,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin ?? 20),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: bgClr,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(buttonText,
                style: GoogleFonts.b612(
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)))),
      ),
    );
  }
}
