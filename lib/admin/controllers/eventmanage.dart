// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EventManageController extends ChangeNotifier {
//   File? _selectedImage;
//   String? _imgUrl;
//
//
//
//   String? _selectedCategory;
//   final CollectionReference _userDetails = FirebaseFirestore.instance
//       .collection("users")
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection("userdetails");
//
//   final CollectionReference _cat =
//       FirebaseFirestore.instance.collection("catagories");
//
//   CollectionReference get cat => _cat;
//   String get selectedCat => _selectedCategory!;
//   File? get selectedImage => _selectedImage;
//
//   void setCat(String cat) {
//     _selectedCategory = cat;
//     notifyListeners();
//   }
//
//   final TextEditingController _titleCtrl = TextEditingController();
//   final TextEditingController _subTitleCtrl = TextEditingController();
//   final TextEditingController _priceCtrl = TextEditingController();
//   final TextEditingController _durationCtrl = TextEditingController();
//   final TextEditingController _locCtrl = TextEditingController();
//   final TextEditingController _dtCtrl = TextEditingController();
//
//   uploadImage(BuildContext context) async {
//     ImagePicker picker = ImagePicker();
//     XFile? store = await picker.pickImage(source: ImageSource.gallery);
//
//     if (store != null) {
//       _selectedImage = File(store.path);
//       notifyListeners();
//
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child("uploadedimage/${_selectedImage!.path}");
//       UploadTask task = ref.putFile(_selectedImage!);
//
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return const AlertDialog(
//               title: Text("please wait"),
//             );
//           },
//         );
//       }
//
//       await task.whenComplete(() async {
//         Navigator.pop(context);
//
//         var url = await ref.getDownloadURL();
//         _imgUrl = url;
//       });
//     }
//   }
//
//   newEvent(
//       {required String title,
//       required String subTitle,
//       required int price,
//       required String duration,
//       required String location,
//       required String dt}) async {
//     await FirebaseFirestore.instance.collection("itemss").add({
//       "catid": _selectedCategory,
//       "title": title,
//       "subtitle": subTitle,
//       "price": price,
//       "duration": duration,
//       "location": location,
//       'datetime': dt,
//       "image": _imgUrl
//     });
//   }
// }
