import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/user/screens/detailsandbook.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatagoriesDataView extends StatefulWidget {
  const CatagoriesDataView(
      {super.key,
      // required this.docId,
      this.name,
      this.catid});

  // final String docId;
  final String? name;
  final String? catid;

  @override
  State<CatagoriesDataView> createState() => _CatagoriesDataViewState();
}

class _CatagoriesDataViewState extends State<CatagoriesDataView> {
  String? location;
  String? needsLoc;

  getdata() async {
    SharedPreferences get = await SharedPreferences.getInstance();
    var city = get.getString("loc");
    if (city != null) {
      location = city;
      setState(() {});
    }
  }

  @override
  void initState() {
    getdata();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(widget.name ?? "Trending"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (needsLoc == null) {
                    needsLoc = location;

                    Fluttertoast.showToast(
                      msg: "Events based on selected location",
                    );
                  } else {
                    needsLoc = null;
                  }
                });
              },
              icon: needsLoc == null
                  ? const Icon(Icons.location_off)
                  : const Icon(Icons.location_on)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("itemss")
              .where("catid", isEqualTo: widget.catid)
              .where("location", isEqualTo: needsLoc)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No event found"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return DetailsBook(
                              docid: snapshot.data!.docs[index].id,
                              name: snapshot.data!.docs[index]['title']);
                        },
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
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        snapshot.data!.docs[index]['image']),
                                    fit: BoxFit.fill),
                                color: Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            height: 170,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  snapshot.data!.docs[index]['title'],
                                  style: GoogleFonts.oswald(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  snapshot.data!.docs[index]['subtitle'],
                                  style: GoogleFonts.oswald(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                Icons.calendar_today,
                                size: 17,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data!.docs[index]['datetime'],
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
                                width: 8,
                              ),
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data!.docs[index]['location'],
                                style: GoogleFonts.oswald(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            //height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]['price']
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 30,
                                  width: 2,
                                  child: const Text(""),
                                ),
                                const Text(
                                  "BUY NOW",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
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
