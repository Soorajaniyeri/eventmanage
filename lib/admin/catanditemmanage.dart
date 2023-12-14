import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/const/cities.dart';
import 'package:myproject/widgets/buttonDesign.dart';
import 'package:myproject/widgets/textfielddesign.dart';

class CatItemManage extends StatefulWidget {
  const CatItemManage({super.key});

  @override
  State<CatItemManage> createState() => _CatItemManageState();
}

class _CatItemManageState extends State<CatItemManage> {
  File? selectedImage;
  String? imgUrl;
  String? date;

  String? selectedCity;
  String? selectedLoc;
  CollectionReference userDetails = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("userdetails");
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController subTitleCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController locCtrl = TextEditingController();
  TextEditingController dtCtrl = TextEditingController();

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

  newEvent(
      {required String title,
      required String subTitle,
      required int price,
      required String duration,
      required String location,
      required String dt}) async {
    await FirebaseFirestore.instance.collection("itemss").add({
      "catid": selectedCategory,
      "title": title,
      "subtitle": subTitle,
      "price": price,
      "duration": duration,
      "location": location,
      'datetime': dt,
      "image": imgUrl
    });
  }

  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: StreamBuilder(
            stream: userDetails.snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!.docs[0]['dp']),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Manage Events"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("catagories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DropdownMenuItem<String>> dropdownMenuEntries = [];
                  for (var doc in snapshot.data!.docs) {
                    String categoryTitle = doc['name'];
                    dropdownMenuEntries.add(DropdownMenuItem<String>(
                      value: categoryTitle,
                      child: Text(categoryTitle),
                    ));
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("choose Catagorie"),
                      const SizedBox(
                        width: 30,
                      ),
                      DropdownButton(
                        hint: const Text("hello"),
                        value: selectedCategory,
                        items: dropdownMenuEntries,
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
          const SizedBox(
            height: 10,
          ),
          TextFieldDesign(
              brdrClr: Colors.black,
              hintText: "Event title",
              controller: titleCtrl),
          const SizedBox(
            height: 10,
          ),
          TextFieldDesign(
              brdrClr: Colors.black,
              hintText: "Event subtitle",
              controller: subTitleCtrl),
          const SizedBox(
            height: 10,
          ),
          ButtonDesign(
              margin: 90,
              buttonText: "Upload Image",
              onTap: () {
                uploadImage();
              }),
          selectedImage == null
              ? const SizedBox()
              : Image(height: 50, width: 50, image: FileImage(selectedImage!)),
          const SizedBox(
            height: 10,
          ),
          TextFieldDesign(
              brdrClr: Colors.black,
              hintText: 'Event ticket Prize',
              controller: priceCtrl),
          const SizedBox(
            height: 10,
          ),
          TextFieldDesign(
              brdrClr: Colors.black,
              hintText: "Duration",
              controller: durationCtrl),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Choose event Location"),
              const SizedBox(
                width: 30,
              ),
              DropdownButton(
                  hint: const Text("Location"),
                  value: selectedLoc,
                  items: const [
                    DropdownMenuItem(value: "Kannur", child: Text("Kannur")),
                    DropdownMenuItem(value: "Calicut", child: Text("Calicut")),
                    DropdownMenuItem(
                      value: "Kochin",
                      child: Text("Kochin"),
                    ),
                    DropdownMenuItem(
                      value: "Trivandrum",
                      child: Text("Trivandrum"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLoc = value as String;
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonDesign(
              margin: 90,
              buttonText: "Choose Date",
              onTap: () async {
                DateTime? store = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2024));
                if (store != null) {
                  date = "${Consts().cities[store.month]} ${store.day}";
                }
              }),
          const SizedBox(
            height: 10,
          ),
          ButtonDesign(
              margin: 90,
              buttonText: "Submit",
              onTap: () {
                newEvent(
                    title: titleCtrl.text,
                    subTitle: subTitleCtrl.text,
                    price: int.parse(priceCtrl.text),
                    duration: "${durationCtrl.text} Hr",
                    location: selectedLoc!,
                    dt: date!);
              }),
        ]),
      )),
    );
  }
}
