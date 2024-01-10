import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ticket_widget/ticket_widget.dart';

class UserBookings extends StatelessWidget {
  const UserBookings({super.key});

  bookingStatus({required bool status}) {
    if (status == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.green.shade500,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
            child: Center(
              child: Text("CONFIRMED",
                  style: GoogleFonts.b612(
                      textStyle: const TextStyle(color: Colors.white))),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
            child: Center(
              child: Text(
                "PENDING",
                style: GoogleFonts.b612(),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          "Your Orders",
          style: GoogleFonts.b612(textStyle: const TextStyle(fontSize: 17)),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("bookings")
              .where("userid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  backgroundColor: Colors.white,
                ),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Booking Found"),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          shape: const Border.symmetric(
                              horizontal: BorderSide.none),
                          isScrollControlled: true,
                          // backgroundColor: Colors.grey.shade100,
                          context: context,
                          builder: (context) => Container(
                                color: Colors.grey.shade300,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          "Your Ticket",
                                          style: GoogleFonts.b612(
                                              textStyle: const TextStyle(
                                                  fontSize: 17)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.black45,
                                            radius: 16,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              child: Center(
                                                  child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    snapshot.data!.docs[index]['status'] ==
                                            false
                                        ? Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Colors.black45),
                                            child: const Center(
                                              child: Text(
                                                "Booking still in pending try again later",
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade500,
                                            spreadRadius: 5,
                                            blurRadius: 30)
                                      ]),
                                      child: TicketWidget(
                                          isCornerRounded: true,
                                          width: 300,
                                          height: 400,
                                          child: Column(
                                            children: [
                                              Image(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['image'])),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['title'],
                                                          style: GoogleFonts
                                                              .oswald(),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['datetime'],
                                                            style: GoogleFonts.oswald(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300)),
                                                          ),
                                                          const Text("  |  "),
                                                          Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['loc'],
                                                            style: GoogleFonts.oswald(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300)),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data!.docs[index]['tcount']} Tickets",
                                                            style: GoogleFonts.oswald(
                                                                textStyle: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300)),
                                                          ),
                                                          const Text("  |  "),
                                                          Text(
                                                            "${snapshot.data!.docs[index]['tprize']} Rupees",
                                                            style: GoogleFonts
                                                                .oswald(
                                                                    textStyle:
                                                                        const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      snapshot.data!.docs[index]
                                                                  ['status'] ==
                                                              true
                                                          ? BarcodeWidget(
                                                              height: 100,
                                                              width: 100,
                                                              data: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['unique'],
                                                              barcode: Barcode
                                                                  .qrCode())
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      snapshot.data!.docs[index]
                                                                  ['status'] ==
                                                              true
                                                          ? Text(
                                                              "Booking id : ${snapshot.data!.docs[index]['unique']}",
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .grey),
                                                            )
                                                          : Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  "Your Qrcode will show here",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                    const Expanded(child: SizedBox())
                                  ],
                                ),
                              ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      margin: const EdgeInsets.all(10),
                      width: 250,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            snapshot.data!.docs[index]
                                                ['image']),
                                        fit: BoxFit.fill),
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                height: 170,
                              ),
                              bookingStatus(
                                  status: snapshot.data!.docs[index]['status'])
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      snapshot.data!.docs[index]['title'],
                                      style: GoogleFonts.oswald(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['datetime'],
                                        style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w300)),
                                      ),
                                      const Text("  |  "),
                                      Text(
                                        snapshot.data!.docs[index]['loc'],
                                        style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w300)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${snapshot.data!.docs[index]['tcount']} Tickets",
                                        style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w300)),
                                      ),
                                      const Text("  |  "),
                                      Text(
                                        "${snapshot.data!.docs[index]['tprize']} Rupees",
                                        style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              snapshot.data!.docs[index]['status'] == false
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Your Qrcode will show here",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    )
                                  : BarcodeWidget(
                                      height: 75,
                                      width: 75,
                                      data: snapshot.data!.docs[index]
                                          ['unique'],
                                      barcode: Barcode.qrCode()),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // Text(
                          //   snapshot.data!.docs[index]['location'],
                          //   style: GoogleFonts.oswald(
                          //       textStyle:
                          //       TextStyle(fontWeight: FontWeight.w300)),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
