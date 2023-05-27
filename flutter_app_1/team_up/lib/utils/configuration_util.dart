import 'package:flutter/material.dart';

import '../screens/add_tasks_screen.dart';
import '../screens/home_screen.dart';
import '../screens/student_progress_screen.dart';

class ConfigUtils {
  static void goToScreen(Widget screen, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static Container configForNavMenu(BuildContext context) {
    // return Stack(
    // // Stacks the menu and regular content
    // children: [
    //   // This handles the menu overlay feature
    //   AnimatedOpacity(
    //     duration: Duration(milliseconds: 200),
    //     opacity: isExpanded ? 1.0 : 0.0,
    // child:
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('Add Tasks Page'),
            onTap: () {
              goToScreen(const AddTasksScreen(), context);
            },
          ),
          ListTile(
            title: Text('Student Progress Page'),
            onTap: () {
              goToScreen(const StudentProgressScreen(), context);
            },
          ),
          ListTile(
            title: Text('Home Page'),
            onTap: () {
              goToScreen(const HomeScreen(), context);
            },
          ),
        ],
      ),
    );
  }
}
