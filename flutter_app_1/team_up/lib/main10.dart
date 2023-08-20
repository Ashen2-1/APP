import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:team_up/screens/home_screen.dart';
import 'screens/countdown-page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0,vertical: 20),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              onTabChange: (index){ ///// Here the index is the icon index the 1st icon have an index of 0 the 2nd have a index of 1 and so on
                print(index);
              },
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.check_circle_outline_sharp,
                  text: "Approve",
          
                ),
                GButton(
                  icon: Icons.people_alt_outlined,
                  text: "Teams",
                ),
                GButton(
                  icon: Icons.settings,
                  text: "Setting",
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
