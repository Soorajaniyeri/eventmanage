import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/admin/controllers/eventupdatecontroller.dart';

import 'package:myproject/widgets/buttonDesign.dart';
import 'package:myproject/widgets/textfielddesign.dart';
import 'package:provider/provider.dart';

class EventUpdateFinal extends StatefulWidget {
  const EventUpdateFinal({super.key, required this.title, required this.docId});

  final String title;
  final String docId;

  @override
  State<EventUpdateFinal> createState() => _EventUpdateFinalState();
}

class _EventUpdateFinalState extends State<EventUpdateFinal> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController subtitleCtrl = TextEditingController();
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  String? selectedCatId;
  // String? selectedDate;
  String? selectedLocation;

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

  updateEvent(
      {required String docId,
      required String title,
      required String subTitle,
      required String duration,
      required String price,
      required String location,
      required String catId,
      required String imgUrl,
      required String date}) {
    FirebaseFirestore.instance.collection("itemss").doc(docId).update({
      "title": title,
      "subtitle": subTitle,
      "duration": duration,
      "price": int.parse(price),
      "location": location,
      "catid": catId,
      "datetime": date,
    });
  }

  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<EventUpdateController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("itemss")
                .doc(widget.docId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                titleCtrl.text = data!['title'];
                subtitleCtrl.text = data['subtitle'];
                durationCtrl.text = data['duration'];
                priceCtrl.text = data['price'].toString();
                selectedCatId = data['catid'];
                selectedLocation = data['location'];
                imgUrl = data['image'];
                obj.selectedDate = data['datetime'];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldDesign(
                          hintText: "Event title", controller: titleCtrl),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldDesign(
                          hintText: "Event subtitle", controller: subtitleCtrl),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldDesign(
                          inputType: TextInputType.number,
                          hintText: "Event duration",
                          controller: durationCtrl),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldDesign(
                          inputType: TextInputType.number,
                          hintText: "Event price",
                          controller: priceCtrl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Select Event Location"),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              DropdownMenu(
                                  initialSelection: data['location'],
                                  hintText: data['location'],
                                  onSelected: (value) {
                                    selectedLocation = value.toString();
                                  },
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(
                                        value: "Kannur", label: "Kannur"),
                                    DropdownMenuEntry(
                                        value: "Calicut", label: "Calicut"),
                                    DropdownMenuEntry(
                                        value: "Kochin", label: "Kochin"),
                                    DropdownMenuEntry(
                                        value: "Trivandrum",
                                        label: "Trivandrum")
                                  ]),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Select Event Catagorie"),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              DropdownMenu(
                                  initialSelection: data['catid'],
                                  hintText: data['catid'],
                                  onSelected: (value) {
                                    selectedCatId = value.toString();
                                  },
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(
                                        value: "performance",
                                        label: "performance"),
                                    DropdownMenuEntry(
                                        value: "music", label: "music"),
                                    DropdownMenuEntry(
                                        value: "screening", label: "screening"),
                                    DropdownMenuEntry(
                                        value: "parties", label: "parties")
                                  ]),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: selectedImage != null
                                    ? FileImage(selectedImage!) as ImageProvider
                                    : CachedNetworkImageProvider(data['image']),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 30,
                                child: IconButton(
                                    onPressed: () {
                                      uploadImage();
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<EventUpdateController>(
                        builder: (context, value, child) {
                          return MaterialButton(
                              textColor: Colors.white,
                              height: 50,
                              color: Colors.black,
                              onPressed: () async {
                                value.chooseDate(context);
                              },
                              child: Text(value.selectedDate ?? "choose date"));
                        },
                      ),
                      Text(data['datetime']),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonDesign(
                          buttonText: "Update data",
                          onTap: () {
                            updateEvent(
                                docId: data.id,
                                title: titleCtrl.text.trim(),
                                subTitle: subtitleCtrl.text.trim(),
                                duration: "${durationCtrl.text.trim()} Hr",
                                price: priceCtrl.text.trim(),
                                location: selectedLocation!,
                                catId: selectedCatId!,
                                imgUrl: imgUrl!,
                                date: obj.selectedDate!);
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
