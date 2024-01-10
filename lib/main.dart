import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myproject/admin/controllers/adminbooking.dart';
import 'package:myproject/admin/controllers/eventupdatecontroller.dart';
import 'package:myproject/firebase_options.dart';
import 'package:myproject/user/controlllers/navigation_controller.dart';


import 'package:myproject/user/screens/splashscreen.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AdminBooking()),
          ChangeNotifierProvider(create: (context) => NavigationController()),
          ChangeNotifierProvider(create: (context) => EventUpdateController()),
        ],
        child: MaterialApp(

            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home:

            const SplashScreen()));
  }
}
