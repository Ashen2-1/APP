import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
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
  int _time = -1;

  List<String> tasksList = [];
  List<String> dueDates = [];
  List<String> skillsNeeded = [];

  List<String> imageUrlList = [];

 
  //List<Image> resizedImageList = [];
  // List<Widget> taskBoxes = [];

  Future<void> addDynamicTaskFields(BuildContext context) async {
    List<Map<String, dynamic>>? queryResults =
        await DatabaseAccess.getInstance()
            .getAvailableTasks(_time, StudentData.getQuerySubTeam());

    FlutterLogs.logInfo(
        "MAINFRAME", "put widgets on screen", "query results: ${queryResults}");

    for (Map<String, dynamic> taskMap in queryResults!) {
      tasksList.add(taskMap['task']);
      dueDates.add(taskMap['due date']);
      skillsNeeded.add(taskMap['skills needed']);
      imageUrlList.add(taskMap['image url']);


    
    }
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
        body: buildMainContent() //ConfigUtils.configForNavMenu(
        //buildMainContent, _isExpanded, context))
        );
  }

  Widget buildMainContent() {
    FlutterLogs.logInfo("Student Progress Screen", "Query Subteam",
        "Current: ${StudentData.getQuerySubTeam()}");
    return SingleChildScrollView(
        child: Column(children: [
      const Text("Available time: "),
      ListTile(
        title: const Text('10 mins'),
        leading: Radio<int>(
          value: 10,
          groupValue: _time,
          onChanged: (int? value) {
            setState(() {
              _time = value!;
            });
          },
        ),
      ),
      ListTile(
        title: const Text('20 mins'),
        leading: Radio<int>(
          value: 20,
          groupValue: _time,
          onChanged: (int? value) {
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
        addDynamicTaskFields(context);
      }),
      SizedBox(
          height: 600.0,
          child: ListView.builder(
            itemCount: dueDates.length,
            itemBuilder: (context, index) {
              return textFieldTaskInfo(tasksList[index], dueDates[index],
                  skillsNeeded[index], imageUrlList[index], true, context);
            },
          )),
    ]));
  }
}
