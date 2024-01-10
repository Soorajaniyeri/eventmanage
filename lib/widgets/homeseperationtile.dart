import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class HomeSeperationTile extends StatelessWidget {
  const HomeSeperationTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon, required this.action
  });

  final String title;
  final String subTitle;
  final Icon icon;
  final void Function ()action ;


  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300, child: icon),
        title: Text(title,
            style: GoogleFonts.oswald(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            )),
        subtitle: Text(subTitle,
            style: GoogleFonts.oswald(
                textStyle: const TextStyle(fontWeight: FontWeight.w300))),
        trailing: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap:action ,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.white),
            child: const Text(
              "VIEW ALL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}