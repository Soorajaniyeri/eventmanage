import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class HomeEventWidget extends StatelessWidget {
  const HomeEventWidget(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.subTitle,
      required this.price,
      required this.dat,
      required this.loc,
      this.action,
      required this.catLabel});

  final String imgUrl;
  final String title;
  final String subTitle;
  final int price;
  final String dat;
  final String loc;
  final String catLabel;
  final void Function()? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      onTap: action,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.all(10),
        width: 250,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(imgUrl),
                          fit: BoxFit.fill),
                      color: Colors.black,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 7),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 3),
                      child: Center(
                        child: Text(
                          catLabel,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    title,
                    style: GoogleFonts.oswald(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    subTitle,
                    style: GoogleFonts.oswald(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 13,
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  dat,
                  style: GoogleFonts.oswald(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300)),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.location_on,
                  size: 18,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  loc,
                  style: GoogleFonts.oswald(
                      textStyle: const TextStyle(fontWeight: FontWeight.w300)),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              //height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "$price Onwards",
                    style: GoogleFonts.oswald(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    color: Colors.white,
                    height: 30,
                    width: 2,
                    child: const Text(""),
                  ),
                  Text(
                    "BUY NOW",
                    style: GoogleFonts.oswald(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
