import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/admin/views/bookingss.dart';
import 'package:myproject/admin/views/update_event.dart';

import 'package:myproject/user/screens/splashscreen.dart';

import '../catanditemmanage.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final List<Map<String, dynamic>> items = [
    {
      "name": "Manage Events",
      "image": "assets/etm.png",
    },
    {"name": "Manage Bookings", "image": "assets/mb.png"},
    {"name": "Manage Users", "image": "assets/mu.png"},
    {"name": "Manage Users", "image": "assets/etm.png"}
  ];

  void openScreen({required int index}) {
    if (index == 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CatItemManage()));
                    },
                    child: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Image(
                              height: 60, image: AssetImage("assets/etm.png")),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Add new Event ",
                            style: GoogleFonts.abel(),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const UpdateEvent();
                        },
                      ));
                    },
                    child: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Image(
                              height: 60, image: AssetImage("assets/etm.png")),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            " Update Event ",
                            style: GoogleFonts.abel(),
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ));
    }

    if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AdminBookings()));
    }
  }

  userLogin() async {
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "aniyerisooraj@gmail.com", password: "225566");

    if (context.mounted) {
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const SplashScreen();
                    },
                  ), (route) => false);
                }
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("itemss").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                    snapshot.data!.docs[index]['image']))),
                      );
                    },
                    options: CarouselOptions(
                        viewportFraction: 0.9,
                        height: 190,
                        autoPlay: true,
                        enlargeCenterPage: true));
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Text(
                "Manage",
                style: GoogleFonts.robotoMono(
                    textStyle: const TextStyle(fontSize: 17)),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      openScreen(index: index);
                    },
                    child: SizedBox(
                      height: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Image(
                              height: 60,
                              image: AssetImage(items[index]['image']!)),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: Text(
                            items[index]['name']!,
                            style: GoogleFonts.abel(),
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
