import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myproject/widgets/buttonDesign.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/textfielddesign.dart';
import 'loginscreen.dart';
import 'navigationscreen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  bool hide = false;

  userRegistration({required email, required password}) async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                )
              ],
            ),
          );
        },
      );

      UserCredential userData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userData.user!.uid)
          .collection("userdetails")
          .add({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "dp":
            "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjHnSRXPSLrljeRy0jZvZM6mlJhbrleSFpvqBr3XQofZatDL5r0sUjxgN9N4vKpifLTds1vWlmsTt-XeN1wbIo7Kj0qSLbfeScRd5IFbel1NewpL1bX09nj9JZ3NcGLaGDtabL5VwUwfZzPca_9b_bQoxOkH3xKlB0Cg5u6PN5zHRSIJBYDmWvRHRuhNmQ/s1600/user%20%282%29.png"
      });

      if (userData.user != null) {
        Fluttertoast.showToast(
            msg: "Successfully Registered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationScreen()));
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "weak-password") {
        Fluttertoast.showToast(
            msg: "Password should be at least 6 characters",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (error.code == "invalid-email") {
        Fluttertoast.showToast(
            msg: "Please check your email address",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (error.code == "email-already-in-use") {
        Fluttertoast.showToast(
            msg: "Email Already Registered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(height: 70, image: AssetImage("assets/icon.png")),
              const SizedBox(
                height: 30,
              ),
              TextFieldDesign(
                  hintText: "Enter Your name", controller: nameCtrl),
              const SizedBox(
                height: 10,
              ),
              TextFieldDesign(
                  inputType: TextInputType.emailAddress,
                  hintText: "Enter Your email",
                  controller: emailCtrl),
              const SizedBox(
                height: 10,
              ),
              TextFieldDesign(
                  secure: true,
                  hintText: "Enter Your password",
                  controller: passCtrl),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonDesign(
                  buttonText: "Create Account",
                  onTap: () {
                    if (nameCtrl.text.isEmpty ||
                        emailCtrl.text.isEmpty ||
                        passCtrl.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(),
                            title: Text(
                              "Please fill all fields",
                              style: GoogleFonts.elMessiri(),
                            ),
                          );
                        },
                      );
                    }

                    userRegistration(
                        email: emailCtrl.text, password: passCtrl.text);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account..??",
                    style: GoogleFonts.oswald(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      },
                      child: Text(
                        " Login now ",
                        style: GoogleFonts.oswald(
                            textStyle: const TextStyle(color: Colors.black)),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
