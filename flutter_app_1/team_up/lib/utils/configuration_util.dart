import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_tasks_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/add_tasks_screen.dart';
import '../screens/home_screen.dart';
import '../screens/student_progress_screen.dart';

class ConfigUtils {
  static List<Widget> previousScreens = [];
  static Widget? scheduledScreen;
  static void goToScreen(Widget screen, BuildContext context) {
    if (scheduledScreen != null &&
        scheduledScreen.runtimeType != PageNavigationScreen().runtimeType &&
        scheduledScreen != PageNavigationScreen.incomingScreen) {
      previousScreens.add(scheduledScreen!);
      FlutterLogs.logInfo(
          "Navigation", "Go To Screen", "List screens: $previousScreens");
    }
    scheduledScreen = screen;
    FlutterLogs.logInfo("Navigation", "Go To Screen",
        "Scheduled current screen: $scheduledScreen");
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static Widget? getLastScreen() {
    if (previousScreens.isEmpty) {
      return null;
    }
    return previousScreens.removeLast();
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
          // ListTile(
          //   title: Text('Student Progress Page'),
          //   onTap: () {
          //     goToScreen(const StudentProgressScreen(), context);
          //   },
          // ),
          ListTile(
            title: Text('Home Page'),
            onTap: () {
              goToScreen(const HomeScreen(), context);
            },
          ),
          ListTile(
            title: Text('My Tasks Page'),
            onTap: () {
              goToScreen(const StudentTasksScreen(), context);
            },
          ),
        ],
      ),
    );
  }

  static WillPopScope configForBackButtonBehaviour(
      Scaffold Function() mainLayout, BuildContext context) {
    return WillPopScope(
        // to handle back button behaviour press
        onWillPop: () async {
          Widget? lastScreen = getLastScreen();
          if (lastScreen != null) {
            ConfigUtils.goToScreen(lastScreen, context);
          }
          return true;
        },
        child: mainLayout());
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      //WebView(initialUrl: url);
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
      );
    }
  }
}
