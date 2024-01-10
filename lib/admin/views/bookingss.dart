
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/admin/controllers/adminbooking.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class AdminBookings extends StatefulWidget {
  const AdminBookings({super.key});

  @override
  State<AdminBookings> createState() => _AdminBookingsState();
}

class _AdminBookingsState extends State<AdminBookings> {
  String? uniId;

  ticketStatus({required bool value, required String id}) {
    Uuid uuid = const Uuid();
    String data = uuid.v4();
    uniId = data.substring(0, 7);

    FirebaseFirestore.instance
        .collection("bookings")
        .doc(id)
        .update({"status": value, "unique": uniId});
  }

  bool tktStatus = false;

  Widget statusContainer({required bool status}) {
    if (status == false) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.redAccent.shade400,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: 40,
        width: 100,
        child: Center(
          child: Text(
            "PENDING",
            style: GoogleFonts.b612(
                textStyle: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: 40,
        width: 100,
        child: Center(
          child: Text(
            "APPROVED",
            style: GoogleFonts.b612(
                textStyle: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<AdminBooking>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Manage Bookings",
              style: GoogleFonts.b612(),
            ),
            bottom: TabBar(
                labelPadding: const EdgeInsets.all(15),
                labelColor: Colors.blue,
                indicatorColor: Colors.black,
                unselectedLabelColor: Colors.black,
                dividerColor: Colors.white,
                tabs: [
                  Text(
                    "Pending",
                    style: GoogleFonts.b612(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text("Accepted",
                      style: GoogleFonts.b612(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold))),
                ]),
          ),

          // floatingActionButton: FloatingActionButton(
          //     child: Icon(
          //       Icons.visibility,
          //       color: Colors.white,
          //     ),
          //     backgroundColor: Colors.black54,
          //     onPressed: () {
          //       setState(() {
          //         if (tktStatus == true) {
          //           tktStatus = false;
          //         } else {
          //           tktStatus = true;
          //         }
          //       });
          //     }),
          backgroundColor: Colors.white,
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: StreamBuilder(
                stream: obj.bookingData
                    .where("status", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No Pending bookings found'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  color: Colors.grey.shade300),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(data['datetime']),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    children: [
                                      Text(data['tprize'].toString()),
                                      Text("${data['tcount']} tickets")
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // BarcodeWidget(
                              //     height: 80,
                              //     width: 80,
                              //     data: "hello hridya",
                              //     barcode: Barcode.qrCode()),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['title'],
                                      style: GoogleFonts.aboreto(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    data['loc'],
                                    style: GoogleFonts.aboreto(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 9, vertical: 6),
                                  //   decoration: const BoxDecoration(
                                  //       color: Colors.yellow,
                                  //       borderRadius:
                                  //           BorderRadius.all(Radius.circular(10))),
                                  //   child: const Text(
                                  //     "Confirm",
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // )

                                  PopupMenuButton(
                                    icon: const Icon(
                                      Icons.menu,
                                    ),
                                    surfaceTintColor: Colors.white,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                            onTap: () {
                                              ticketStatus(
                                                  value: true, id: data.id);
                                            },
                                            child: const Text("Confirm")),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  statusContainer(
                                      status: snapshot.data!.docs[index]
                                          ['status'])
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No Bookings"));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: StreamBuilder(
                stream: obj.bookingData
                    .where("status", isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No tickets Found'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  color: Colors.grey.shade300),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(data['datetime']),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    children: [
                                      Text(data['tprize'].toString()),
                                      Text("${data['tcount']} tickets")
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              BarcodeWidget(
                                  height: 80,
                                  width: 80,
                                  data: data['unique'],
                                  barcode: Barcode.qrCode()),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Booking id ${data['unique']}",
                                style: GoogleFonts.b612(
                                    textStyle: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['title'],
                                      style: GoogleFonts.aboreto(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    data['loc'],
                                    style: GoogleFonts.aboreto(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 9, vertical: 6),
                                  //   decoration: const BoxDecoration(
                                  //       color: Colors.yellow,
                                  //       borderRadius:
                                  //           BorderRadius.all(Radius.circular(10))),
                                  //   child: const Text(
                                  //     "Confirm",
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // )

                                  // PopupMenuButton(
                                  //   icon: const Icon(
                                  //     Icons.menu,
                                  //   ),
                                  //   surfaceTintColor: Colors.white,
                                  //   itemBuilder: (context) {
                                  //     return [
                                  //       PopupMenuItem(
                                  //           onTap: () {
                                  //             ticketStatus(
                                  //                 value: true, id: data.id);
                                  //           },
                                  //           child: const Text("Confirm")),
                                  //       const PopupMenuItem(
                                  //           child: Text("Reject"))
                                  //     ];
                                  //   },
                                  // ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  statusContainer(
                                      status: snapshot.data!.docs[index]
                                          ['status'])
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No Bookings"));
                  }
                },
              ),
            ),
          ])),
    );
  }
}
