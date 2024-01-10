import 'package:flutter/material.dart';

import '../screens/catagoriespage.dart';
import '../screens/homescreen.dart';
import '../screens/profilescreen.dart';
import '../screens/userbookings.dart';

class NavigationController extends ChangeNotifier {
  List myScreens = [
    const HomePage(),
    const CatagoriesPage(),
    const ProfileScreen(),
    const UserBookings()
  ];
  int index = 0;





  Future<bool> backPress() async {
    if (index != 0) {
      index = 0;
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  screenChange(value) {
    index = value;
    notifyListeners();
  }
}
