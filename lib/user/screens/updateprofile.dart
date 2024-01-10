import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/widgets/buttonDesign.dart';
import 'package:myproject/widgets/textfielddesign.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  CollectionReference userData = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("userdetails");

  TextEditingController name = TextEditingController();

  File? selectedImage;
  String? url;

  uploadPhoto() async {
    ImagePicker picker = ImagePicker();

    XFile? store = await picker.pickImage(source: ImageSource.gallery);

    if (store != null) {
      selectedImage = File(store.path);
      setState(() {});
    }

    // await userData.doc(docid).update({"name": name, "dp": imgurl});
  }

  updateProfile() async {
    if (selectedImage != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("useruploaded${selectedImage!.path}");

      UploadTask task = ref.putFile(selectedImage!);

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  height: 5,
                ),
                Center(child: Text("Please wait while we update your profile"))
              ],
            ),
          );
        },
      );

      task.whenComplete(() async {
        url = await ref.getDownloadURL();
        QuerySnapshot querySnapshot = await userData.get();
        DocumentSnapshot firstDocument = querySnapshot.docs.first;

        await firstDocument.reference.update({"name": name.text, "dp": url});


        if(context.mounted){
          Navigator.pop(context);
        }

      });
    } else {
      QuerySnapshot querySnapshot = await userData.get();
      DocumentSnapshot firstDocument = querySnapshot.docs.first;

      await firstDocument.reference.update({"name": name.text});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: StreamBuilder(
              stream: userData.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  name.text = snapshot.data!.docs[0]['name'];
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(children: [
                          selectedImage == null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data!.docs[0]['dp']))
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(selectedImage!)),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => uploadPhoto(),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25))),
                                child: const Center(child: Icon(Icons.image)),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldDesign(
                            hintText: snapshot.data!.docs[0]['name'],
                            controller: name),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonDesign(
                            buttonText: "Update Profile",
                            onTap: () async {
                              await updateProfile();
                              Fluttertoast.showToast(
                                  msg: "Profile updated Successfully");
                              if(context.mounted){
                                Navigator.pop(context);
                              }

                            })
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ));
  }
}
