import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/constants/colors.dart';
import 'package:team_up/widgets/widgets.dart';

import '../utils/util.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  String _time = "";

  List<Map<String, dynamic>>? queryResults = [];
  //List<Image> resizedImageList = [];
  // List<Widget> taskBoxes = [];

  Future<void> addDynamicTaskFields(BuildContext context) async {
    queryResults = await DatabaseAccess.getInstance()
        .getAvailableTasks(_time, StudentData.getQuerySubTeam());

    FlutterLogs.logInfo(
        "MAINFRAME", "put widgets on screen", "query results: ${queryResults}");
    // tasksList = DatabaseAccess.getInstance().parseData("task", queryResults);
    // dueDates =
    //     DatabaseAccess.getInstance().parseData("due date", queryResults);
    // skillsNeeded =
    //     DatabaseAccess.getInstance().parseData("skills needed", queryResults);

    // for (String imageUrl in imageUrlList) {
    //   resizedImageList.add(await Util.resizeImage(imageUrl, 1 / 8));
    // }
    setState(() {});
  }

  bool _isExpanded = false;
  double _overlayHeight = 0.0;
  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(StudentProgressScreen());
    });
  }

  bool buttonPressed = false;
  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
        appBar: buildAppBar(menuToggleExpansion),
        bottomNavigationBar: buildNavBar(context, 1),
        body: buildMainContent() //ConfigUtils.configForNavMenu(
        //buildMainContent, _isExpanded, context))
        );
  }

  Widget buildMainContent() {
    FlutterLogs.logInfo("Student Progress Screen", "Query Subteam",
        "Current: ${StudentData.getQuerySubTeam()}");
    return Column(children: [
      const Text("Available time (inclusive): "),
      ListTile(
        title: const Text('20 minutes or less'),
        leading: Radio<String>(
          value: '20 minutes or less',
          groupValue: _time,
          onChanged: (String? value) {
            setState(() {
              _time = value!;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('30 minutes - 40 minutes'),
        leading: Radio<String>(
          value: '30 minutes - 40 minutes',
          groupValue: _time,
          onChanged: (String? value) {
            setState(() {
              _time = value!;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('1 hour - 2 hours'),
        leading: Radio<String>(
          value: '1 hour - 2 hours',
          groupValue: _time,
          onChanged: (String? value) {
            setState(() {
              _time = value!;
            });
          },
        ),
      ),
      reusableButton("Search for tasks", context, () async {
        // _tasks_controller.text = await DatabaseAccess.getInstance()
        //     .queryEqual("Programming (example)", "estimated time",
        //         "${_time.toString()} mins");
        await addDynamicTaskFields(context);
      }),
      if (queryResults != null)
        Expanded(
            child: ListView.builder(
          itemCount: queryResults!.length,
          itemBuilder: (context, index) {
            return textFieldTaskInfo(queryResults!,
                StudentData.getQuerySubTeam(), index, "search tasks", context);
          },
        )),
    ]);
  }
}
