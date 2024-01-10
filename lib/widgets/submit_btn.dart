import 'package:flutter/material.dart';

class SubmitButtonDesign extends StatelessWidget {
  final void Function() onTap;
  final Widget buttonText;
  final Color bgClr;
  final double? margin;

  const SubmitButtonDesign(
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
          child: Center(child: buttonText)),
    );
  }
}
