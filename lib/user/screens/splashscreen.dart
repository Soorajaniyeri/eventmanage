import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/user/screens/loginscreen.dart';

import '../../admin/views/adminhome.dart';
import 'navigationscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(const Duration(seconds: 3), () {
        if (FirebaseAuth.instance.currentUser!.uid ==
            "rgt1yPTgOxbOVclDb2AWdOqBy6w2") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return const AdminHomeScreen();
            },
          ), (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return const NavigationScreen();
            },
          ), (route) => false);
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(width: 200, image: AssetImage("assets/icon.png")),
          SizedBox(
            height: 60,
          ),
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
          )
        ],
      )),
    );
  }
}
