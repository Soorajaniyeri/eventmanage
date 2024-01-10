// import 'package:flutter/material.dart';
// import 'package:myproject/admin/controllers/eventmanage.dart';
// import 'package:provider/provider.dart';
//
// import '../../widgets/buttonDesign.dart';
// import '../../widgets/textfielddesign.dart';
//
// class EventManage extends StatelessWidget {
//   const EventManage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final obj = Provider.of<EventManageController>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text("Manage Events"),
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(children: [
//           StreamBuilder(
//               stream: obj.cat.snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<DropdownMenuItem<String>> dropdownMenuEntries = [];
//                   for (var doc in snapshot.data!.docs) {
//                     String categoryTitle = doc['name'];
//                     dropdownMenuEntries.add(DropdownMenuItem<String>(
//                       value: categoryTitle,
//                       child: Text(categoryTitle),
//                     ));
//                   }
//
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("choose Catagorie"),
//                       const SizedBox(
//                         width: 30,
//                       ),
//                       DropdownButton(
//                           hint: const Text("hello"),
//                           value: obj.selectedCat,
//                           items: dropdownMenuEntries,
//                           onChanged: (value) {
//                             obj.setCat(value!);
//                           }),
//                     ],
//                   );
//                 } else {
//                   return const SizedBox();
//                 }
//               }),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFieldDesign(
//               brdrClr: Colors.black,
//               hintText: "Event title",
//               controller: titleCtrl),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFieldDesign(
//               brdrClr: Colors.black,
//               hintText: "Event subtitle",
//               controller: subTitleCtrl),
//           const SizedBox(
//             height: 10,
//           ),
//           ButtonDesign(
//               margin: 90,
//               buttonText: "Upload Image",
//               onTap: () {
//                 obj.uploadImage(context);
//               }),
//          obj.selectedImage == null
//               ? const SizedBox()
//               : Image(height: 50, width: 50, image: FileImage(obj.selectedImage!)),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFieldDesign(
//               brdrClr: Colors.black,
//               hintText: 'Event ticket Prize',
//               controller: obj.),
//           const SizedBox(
//             height: 10,
//           ),
//           TextFieldDesign(
//               brdrClr: Colors.black,
//               hintText: "Duration",
//               controller: durationCtrl),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("Choose event Location"),
//               const SizedBox(
//                 width: 30,
//               ),
//               DropdownButton(
//                   hint: const Text("Location"),
//                   value: selectedLoc,
//                   items: const [
//                     DropdownMenuItem(value: "Kannur", child: Text("Kannur")),
//                     DropdownMenuItem(value: "Calicut", child: Text("Calicut")),
//                     DropdownMenuItem(
//                       value: "Kochin",
//                       child: Text("Kochin"),
//                     ),
//                     DropdownMenuItem(
//                       value: "Trivandrum",
//                       child: Text("Trivandrum"),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       selectedLoc = value as String;
//                     });
//                   }),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ButtonDesign(
//               margin: 90,
//               buttonText: "Choose Date",
//               onTap: () async {
//                 DateTime? store = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2001),
//                     lastDate: DateTime(2024));
//                 if (store != null) {
//                   date = "${Consts().cities[store.month]} ${store.day}";
//                 }
//               }),
//           const SizedBox(
//             height: 10,
//           ),
//           ButtonDesign(
//               margin: 90,
//               buttonText: "Submit",
//               onTap: () {
//                 newEvent(
//                     title: titleCtrl.text,
//                     subTitle: subTitleCtrl.text,
//                     price: int.parse(priceCtrl.text),
//                     duration: "${durationCtrl.text} Hr",
//                     location: selectedLoc!,
//                     dt: date!);
//               }),
//         ]),
//       )),
//     );
//   }
// }
