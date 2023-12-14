import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  CollectionReference bookingData =
      FirebaseFirestore.instance.collection("bookings");

  CollectionReference user = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: bookingData.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              height: 40,
                            ),
                            Row(
                              children: [
                                Text(
                                  data['title'],
                                  style: GoogleFonts.aboreto(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 6),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
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
          )
        ],
      )),
    );
  }
}
