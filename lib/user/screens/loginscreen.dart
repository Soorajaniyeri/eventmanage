import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myproject/user/screens/regscreen.dart';
import 'package:myproject/user/screens/splashscreen.dart';
import 'package:myproject/widgets/textfielddesign.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/buttonDesign.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  userLogin({required email, required password}) async {
    SharedPreferences get = await SharedPreferences.getInstance();
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
          .signInWithEmailAndPassword(email: email, password: password);

      if (userData.user != null) {
        get.setString("loc", "Kannur");
        if (context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SplashScreen()));
        }
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      if (error.code == "INVALID_LOGIN_CREDENTIALS") {
        Fluttertoast.showToast(
            msg: "Invalid login details",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (error.code == "invalid-email") {
        Fluttertoast.showToast(
            msg: "The email address is badly formatted",
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(height: 70, image: AssetImage("assets/icon.png")),
            const SizedBox(
              height: 30,
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
                buttonText: "Login",
                onTap: () {
                  if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "please fill all fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    userLogin(email: emailCtrl.text, password: passCtrl.text);
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account..??",
                  style: GoogleFonts.oswald(),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegScreen();
                      }));
                    },
                    child: Text(
                      " Register now ",
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
    );
  }
}
