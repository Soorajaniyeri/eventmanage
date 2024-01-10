import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/user/screens/catagoriesdataview.dart';
import 'package:myproject/user/screens/catagoriespage.dart';
import 'package:myproject/user/screens/splashscreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/catagorieswidget.dart';
import '../../widgets/homeeventwidget.dart';
import '../../widgets/homeseperationtile.dart';
import 'detailsandbook.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userCity;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  Future getdata() async {
    SharedPreferences get = await SharedPreferences.getInstance();
    var city = get.getString("loc");
    if (city != null) {
      userCity = city;
      setState(() {});
    } else {
      get.setString("loc", "Kannur");
      setState(() {});
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

  Future storedata({required value}) async {
    SharedPreferences get = await SharedPreferences.getInstance();
    await get.setString("loc", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   userLogin();
      // }),
      backgroundColor: const Color(0xfffafafa),
      body: SafeArea(
          child: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Image(
                  width: 150, height: 90, image: AssetImage("assets/icon.png")),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      userCity = "Kannur";
                                      Navigator.pop(context);
                                      storedata(value: userCity);
                                      setState(() {});
                                    },
                                    child: const Text("Kannur")),
                                TextButton(
                                    onPressed: () {
                                      userCity = "Calicut";
                                      storedata(value: userCity);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: const Text("Calicut")),
                                TextButton(
                                    onPressed: () {
                                      userCity = "Kochin";
                                      storedata(value: userCity);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: const Text("Kochin")),
                                TextButton(
                                    onPressed: () {
                                      userCity = "Trivandrum";
                                      storedata(value: userCity);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: const Text("Trivandrum"))
                              ],
                            ),
                          ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.lightBlue,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(userCity ?? "choose city",
                          style: GoogleFonts.robotoMono()),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ))
          ]),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("itemss").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index, realIndex) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return DetailsBook(
                                  docid: snapshot.data!.docs[index].id,
                                  name: snapshot.data!.docs[index]['title']);
                            },
                          ));
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data!.docs[index]['image']))),
                        ),
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
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("itemss")
                .where("location", isEqualTo: userCity ?? "Calicut")
                .snapshots(),
            builder: (context, snapshot) {
              return HomeSeperationTile(
                title: 'TRENDING EVENTS',
                subTitle: 'Trending events around you',
                icon: const Icon(Icons.local_fire_department),
                action: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const CatagoriesDataView(
                        name: "Trending",
                      );
                    },
                  ));
                },
              );
            },
          ),
          SizedBox(
            height: 350,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("itemss")
                    .where("location", isEqualTo: userCity)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (userCity != null) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => HomeEventWidget(
                                catLabel: snapshot.data!.docs[index]['catid'],
                                imgUrl: snapshot.data!.docs[index]['image'],
                                title: snapshot.data!.docs[index]['title'],
                                subTitle: snapshot.data!.docs[index]
                                    ['subtitle'],
                                price: snapshot.data!.docs[index]['price'],
                                dat: snapshot.data!.docs[index]['datetime'],
                                loc: snapshot.data!.docs[index]['location'],
                                action: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsBook(
                                                // catId: "up46DuJEsBV3FdUp7Ffg",
                                                docid: snapshot
                                                    .data!.docs[index].id,
                                                name: snapshot.data!.docs[index]
                                                    ['title'],
                                              )));
                                },
                              ));
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          HomeSeperationTile(
            title: 'POPULAR EVENTS',
            subTitle: 'popular events all over',
            icon: const Icon(Icons.star),
            action: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const CatagoriesDataView(
                    name: "Popular",
                  );
                },
              ));
            },
          ),
          SizedBox(
            height: 350,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("itemss").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Stack(
                              children: [
                                HomeEventWidget(
                                  imgUrl: snapshot.data!.docs[index]['image'],
                                  title: snapshot.data!.docs[index]['title'],
                                  subTitle: snapshot.data!.docs[index]
                                      ['subtitle'],
                                  price: snapshot.data!.docs[index]['price'],
                                  dat: snapshot.data!.docs[index]['datetime'],
                                  loc: snapshot.data!.docs[index]['location'],
                                  action: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailsBook(
                                                  // catId: "up46DuJEsBV3FdUp7Ffg",
                                                  docid: snapshot
                                                      .data!.docs[index].id,
                                                  name: snapshot.data!
                                                      .docs[index]['title'],
                                                )));
                                  },
                                  catLabel: snapshot.data!.docs[index]['catid'],
                                ),
                              ],
                            ));
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          HomeSeperationTile(
            title: 'EVENTS BY GENRE',
            subTitle: 'events by catagories',
            icon: const Icon(Icons.category_rounded),
            action: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const CatagoriesPage();
                },
              ));
            },
          ),
          SizedBox(
              height: 150,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("catagories")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CatagoriesDataView(
                                  name: snapshot.data!.docs[index]['name'],
                                  catid: snapshot.data!.docs[index]['name'],
                                );
                              },
                            ));
                          },
                          child: CatagoriesWidget(
                              imgUrl: snapshot.data!.docs[index]['image'],
                              title: snapshot.data!.docs[index]['name']),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ))
        ],
      )),
    );
  }
}
