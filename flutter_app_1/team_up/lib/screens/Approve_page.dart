import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';

import 'package:team_up/screens/Feedback_page.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/web_view_page.dart';

import '../constants/colors.dart';
import '../services/database_access.dart';
import '../utils/configuration_util.dart';
import '../utils/fonts.dart';
import '../utils/util.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

class Approve_page extends StatefulWidget {
  const Approve_page({Key? key}) : super(key: key);

  @override
  _Approve_pageState createState() => _Approve_pageState();
}

class _Approve_pageState extends State<Approve_page>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(Approve_page());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(() {
      return mainLayout(context);
    }, context);
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(context),
    );
  }

  @override
  Widget buildMainContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Text("Approving task: ${StudentData.approvalTask!['task']}",
              style: defaultFont),
          SizedBox(height: 20),
          Text("Open up file:", style: defaultFont),
          GestureDetector(
              child: Text("${StudentData.approvalTask!['file url']}",
                  style: StudentData.approvalTask!['file url'] != "None"
                      ? const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          decoration: TextDecoration.underline)
                      : defaultFont),
              onDoubleTap: () {
                ConfigUtils.goToScreen(
                    OpenUrlInWebView(
                        url: StudentData.approvalTask!['file url']),
                    context);
              }),
          SizedBox(
            height: 300,
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 88),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Feedback_page()));
                  },
                  child: RoundButton(
                    icon: Icons.close,
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> existingTaskData =
                        StudentData.getApprovalTask()!;

                    existingTaskData['complete percentage'] = "100%";

                    List<Map<String, dynamic>> tasks =
                        Util.matchAndCombineExisting(
                            existingTaskData,
                            await DatabaseAccess.getInstance()
                                .getStudentSubmissions());
                    DatabaseAccess.getInstance().addToDatabase("submissions",
                        StudentData.studentEmail, {"tasks": tasks});
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: RoundButton(
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
