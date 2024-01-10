import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myproject/user/controlllers/navigation_controller.dart';

import 'package:provider/provider.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<NavigationController>(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: WillPopScope(
          onWillPop: () async {
            return await obj.backPress();
          },
          child: GNav(
              selectedIndex: obj.index,
              onTabChange: (value) {
                obj.screenChange(value);
              },
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              tabBackgroundColor: Colors.grey.shade300,
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(icon: Icons.menu, text: "Categories"),
                GButton(icon: Icons.person, text: "My Account"),
                GButton(icon: Icons.event_available, text: "Bookings"),
              ]),
        ),
      ),
      body: obj.myScreens[obj.index],
    );
  }
}
