import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/user/screens/userbookings.dart';

class DetailsBook extends StatefulWidget {
  const DetailsBook({
    super.key,
    required this.docid,
    // required this.catId,
    required this.name,
  });
  // final String catId;
  final String docid;
  final String name;
  @override
  State<DetailsBook> createState() => _DetailsBookState();
}

class _DetailsBookState extends State<DetailsBook> {
  int count = 0;
  num price = 0;

  addBookingData(
      {required String title,
      required String imgUrl,
      required int tCounts,
      required num tPrize,
      required String loc,
      required String dt}) async {
    await FirebaseFirestore.instance.collection("bookings").add({
      "title": title,
      "image": imgUrl,
      "tcount": tCounts,
      "tprize": tPrize,
      "loc": loc,
      "datetime": dt,
      "status": false,
      'userid': FirebaseAuth.instance.currentUser!.uid
    });

    await Fluttertoast.showToast(msg: "Successfully Booked");

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const UserBookings();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(widget.name),
      ),
      // bottomSheet: BottomSheet(
      //   enableDrag:false,
      //   onClosing: (){}, builder: (context) {
      //   return Container();
      // },),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("itemss")
                    .doc(widget.docid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey.shade300,
                        backgroundColor: Colors.black45,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    price = snapshot.data!['price'];
                    return ListView(children: [
                      Image(
                          image: CachedNetworkImageProvider(
                              snapshot.data!['image'])),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 5),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.black),
                              child: Text(
                                snapshot.data!['catid'],
                                style: const TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data!['title'],
                              style: GoogleFonts.oswald(
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data!['datetime'],
                            style: GoogleFonts.oswald(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 18,
                          ),
                          const Icon(
                            Icons.location_on,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data!['location'],
                            style: GoogleFonts.robotoMono(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   child: Divider(),
                      // ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Event Guide",
                            style: GoogleFonts.anton(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17)),
                          ),
                        ],
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListTile(
                            leading: const Icon(Icons.public),
                            title: const Text("Language"),
                            subtitle: Text(
                              "All ",
                              style: GoogleFonts.robotoMono(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                            )),
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListTile(
                          leading: const Icon(Icons.timelapse_rounded),
                          title: const Text("Duration"),
                          subtitle: Text(
                            snapshot.data!['duration'],
                            style: GoogleFonts.robotoMono(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.currency_rupee),
              const SizedBox(
                width: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("itemss")
                      .doc(widget.docid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            snapshot.data!['price'].toString(),
                            style: GoogleFonts.passionOne(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          Text("Onwords",
                              style: GoogleFonts.elMessiri(
                                  textStyle:
                                      const TextStyle(color: Colors.black)))
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              const Expanded(child: SizedBox()),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  count = 1;
                  setState(() {});
                  // obj.count = 1;
                  // tktTyp = null;
                  // setState(() {});

                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("itemss")
                            .doc(widget.docid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return Container(
                                  margin: const EdgeInsets.all(30),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        snapshot.data!['title'],
                                        style: GoogleFonts.robotoMono(
                                            textStyle: const TextStyle(
                                          fontSize: 20,
                                        )),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (count > 1) {
                                                setState(() {
                                                  count--;
                                                  price = price -
                                                      snapshot.data!['price'];
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.remove),
                                            color: Colors.red,
                                          ),
                                          Text(
                                            "$count.Tickets",
                                            style: GoogleFonts
                                                .notoSansIndicSiyaqNumbers(),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                count++;
                                                price = price +
                                                    snapshot.data!['price'];
                                              });
                                            },
                                            icon: const Icon(Icons.add),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                      Text(price.toString()),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        const RoundedRectangleBorder(),
                                                    title: const Center(
                                                        child: Text(
                                                            "Confirm booking")),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(Icons
                                                                .currency_rupee),
                                                            Text(
                                                              price.toString(),
                                                              style: GoogleFonts
                                                                  .notoSansIndicSiyaqNumbers(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            addBookingData(
                                                                title: snapshot
                                                                        .data![
                                                                    'title'],
                                                                imgUrl: snapshot
                                                                        .data![
                                                                    'image'],
                                                                tCounts: count,
                                                                tPrize: price,
                                                                loc: snapshot
                                                                        .data![
                                                                    'location'],
                                                                dt: snapshot
                                                                        .data![
                                                                    'datetime']);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        30),
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                            child: Center(
                                                              child: Text(
                                                                  "Book Now",
                                                                  style: GoogleFonts.actor(
                                                                      textStyle: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w800))),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.black),
                                              child: Center(
                                                child: Text(
                                                  "Checkout",
                                                  style: GoogleFonts.robotoMono(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text("Book Ticket Now",
                        style: GoogleFonts.russoOne(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                  // height: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
