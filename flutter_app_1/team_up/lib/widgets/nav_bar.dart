import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:team_up/profilesetting.dart';
import 'package:team_up/proflie.dart';
import 'package:team_up/screens/Approve_page.dart';
import 'package:team_up/screens/all_approve_tasks_screen.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/my_team_page.dart';
import 'package:team_up/screens/settings_page.dart';
import 'package:team_up/screens/tasks_page.dart';
import 'package:team_up/utils/configuration_util.dart';

Widget buildNavBar(BuildContext context, int currentIndex) {
  const possibleScreens = [
    HomeScreen(),
    TasksPage(),
    MyTeamPage(),
    Profilesettingpage()
  ];

  return Container(
    color: Colors.black,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: GNav(
        selectedIndex: currentIndex,
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade800,
        gap: 8,
        onTabChange: (index) {
          ///// Here the index is the icon index the 1st icon have an index of 0 the 2nd have a index of 1 and so on
          ConfigUtils.goToScreen(possibleScreens[index], context);
        },
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          //if (f)
          GButton(
            icon: Icons.assignment_outlined,
            text: "Tasks",
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
  );
}
