import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/admin/views/final_event_update.dart';

class UpdateEvent extends StatefulWidget {
  const UpdateEvent({super.key});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  void deleteEvent({required String docId}) async {
    await FirebaseFirestore.instance.collection("itemss").doc(docId).delete();
  }

  File? selectedImage;
  String? imgUrl;

  uploadImage() async {
    ImagePicker picker = ImagePicker();
    XFile? store = await picker.pickImage(source: ImageSource.gallery);

    if (store != null) {
      setState(() {
        selectedImage = File(store.path);
      });

      Reference ref = FirebaseStorage.instance
          .ref()
          .child("uploadedimage/${selectedImage!.path}");
      UploadTask task = ref.putFile(selectedImage!);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("please wait"),
            );
          },
        );
      }

      await task.whenComplete(() async {
        Navigator.pop(context);

        var url = await ref.getDownloadURL();
        imgUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("itemss").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    surfaceTintColor: Colors.white,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EventUpdateFinal(
                              title: snapshot.data!.docs[index]['title'],
                              docId: snapshot.data!.docs[index].id,
                            );
                          },
                        ));
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data!.docs[index]['image']),
                      ),
                      title: Text(snapshot.data!.docs[index]['title']),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                      snapshot.data!.docs[index]["subtitle"])),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(snapshot
                                      .data!.docs[index]["price"]
                                      .toString())),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Are you sure want to delete this event??",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(snapshot.data!.docs[index]['title'])
                                    ],
                                  ),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          deleteEvent(
                                              docId: snapshot
                                                  .data!.docs[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Delete")),
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Later"))
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  );
                });
          } else {
            return const SizedBox();
          }
        },
      )),
    );
  }
}
