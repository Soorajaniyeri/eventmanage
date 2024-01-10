import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatagoriesWidget extends StatelessWidget {
  const CatagoriesWidget(
      {super.key, required this.imgUrl, required this.title});

  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              height: 40,
              image: CachedNetworkImageProvider(imgUrl)),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: GoogleFonts.oswald(),
          ),
        ],
      ),
    );
  }
}
