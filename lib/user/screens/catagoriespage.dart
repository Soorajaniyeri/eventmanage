import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'catagoriesdataview.dart';

class CatagoriesPage extends StatefulWidget {
  const CatagoriesPage({super.key});

  @override
  State<CatagoriesPage> createState() => _CatagoriesPageState();
}

class _CatagoriesPageState extends State<CatagoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Browse by Genre"),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("catagories").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatagoriesDataView(
                                      name: snapshot.data!.docs[index]['name'],
                                      catid: snapshot.data!.docs[index]['name'],
                                    ))),
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  height: 40,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data!.docs[index]['image'])),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data!.docs[index]['name'],
                                style: GoogleFonts.oswald(),
                              ),
                            ],
                          ),
                        ),
                      ));
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
