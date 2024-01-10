import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/user/screens/splashscreen.dart';
import 'package:myproject/user/screens/updateprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? location;

  signOut() async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const SplashScreen();
        },
      ));
    }
  }

  getLocation() async {
    SharedPreferences get = await SharedPreferences.getInstance();
    String? store = get.getString("loc");

    if (store != null) {
      location = store;
      setState(() {});
    }
  }

  Future storedata({required value}) async {
    SharedPreferences get = await SharedPreferences.getInstance();
    await get.setString("loc", value);
  }

  @override
  void initState() {
    getLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpdateProfile()));
                    },
                    child: const Text("Update Profile")),
                PopupMenuItem(
                  child: const Text("Logout"),
                  onTap: () {
                    signOut();
                  },
                )
              ];
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("userdetails")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          snapshot.data!.docs[0]['dp']),
                      radius: 50,
                    ),
                    Text(snapshot.data!.docs[0]['name'],
                        style: GoogleFonts.robotoMono(
                            textStyle: const TextStyle(fontSize: 20),
                            fontWeight: FontWeight.bold)),
                    Text(snapshot.data!.docs[0]['email'],
                        style: GoogleFonts.robotoMono(
                          textStyle: const TextStyle(
                              fontSize: 16, overflow: TextOverflow.ellipsis),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                location = "Kannur";
                                                Navigator.pop(context);
                                                storedata(value: location);
                                                setState(() {});
                                              },
                                              child: const Text("Kannur")),
                                          TextButton(
                                              onPressed: () {
                                                location = "Calicut";
                                                storedata(value: location);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text("Calicut")),
                                          TextButton(
                                              onPressed: () {
                                                location = "Kochin";
                                                storedata(value: location);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text("Kochin")),
                                          TextButton(
                                              onPressed: () {
                                                location = "Trivandrum";
                                                storedata(value: location);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text("Trivandrum"))
                                        ],
                                      ),
                                    ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade100),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 17,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(location ?? "select location"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
