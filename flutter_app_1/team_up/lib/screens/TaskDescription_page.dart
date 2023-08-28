import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/web_view_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import '../constants/student_data.dart';
import '../services/file_uploader.dart';
import '../utils/fonts.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';

class TaskDescription_page extends StatefulWidget {
  const TaskDescription_page({Key? key}) : super(key: key);

  @override
  _TaskDescription_pageState createState() => _TaskDescription_pageState();
}

class _TaskDescription_pageState extends State<TaskDescription_page> {
  //List<Image> resizedImageList = [];
  // List<Widget> taskBoxes = [];

  late AnimationController controller;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(231, 178, 34, 230),
        title: const Text(
          "Descriptions",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: buildNavBar(context, 1),
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Text(
                "Task: ${StudentData.allViewingTask![StudentData.viewingIndex!]['task']}", ////${StudentData.currentDescrption!}, ${addDynamicTaskFields(context)}
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "Task Description: ${StudentData.allViewingTask![StudentData.viewingIndex!]['description']}",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "Task time: ${StudentData.allViewingTask![StudentData.viewingIndex!]['estimated time']}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            if (StudentData.allViewingTask![StudentData.viewingIndex!]
                    ['finish time'] !=
                null)
              Center(
                child: Text(
                  "Time Due: ${Util.formatDateTime(StudentData.allViewingTask![StudentData.viewingIndex!]['finish time'].toDate())}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (StudentData.allViewingTask![StudentData.viewingIndex!]
                    ['machine needed'] !=
                null)
              Center(
                child: Text(
                  "Machine Needed: ${StudentData.allViewingTask![StudentData.viewingIndex!]['machine needed']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (StudentData.allViewingTask![StudentData.viewingIndex!]
                    ['feedback'] !=
                "None")
              Center(
                child: Text(
                  "Feedback: ${StudentData.allViewingTask![StudentData.viewingIndex!]['feedback']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (StudentData.allViewingTask![StudentData.viewingIndex!]
                    ['complete percentage'] !=
                "None")
              Center(
                child: Text(
                  "Complete percentage: ${StudentData.allViewingTask![StudentData.viewingIndex!]['complete percentage']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 25),
            if (StudentData.allViewingTask![StudentData.viewingIndex!]
                    ['image url'] !=
                "None")
              Expanded(
                  child: Image.network(
                      StudentData.allViewingTask![StudentData.viewingIndex!]
                          ['image url'])),
            const SizedBox(
              height: 40,
            ),
            if (StudentData.descriptionIncomingPage == "search tasks")
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () async {
                  ///// add the task to my task page
                  askConfirmation(
                          context,
                          StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['task'])
                      .then((confirmation) async {
                    if (confirmation != null && confirmation) {
                      FlutterLogs.logInfo("TASK FIELD", "Sign up button",
                          "Adding ${StudentData.allViewingTask![StudentData.viewingIndex!]['task']}");
                      Map<String, dynamic> taskToAdd = StudentData
                          .allViewingTask![StudentData.viewingIndex!];
                      taskToAdd['completer'] = StudentData.studentEmail;
                      taskToAdd['completed'] = false;
                      taskToAdd['approved'] = false;
                      taskToAdd['feedback'] = "None";
                      taskToAdd['complete percentage'] = "None";
                      List<Map<String, dynamic>> curTasks =
                          await Util.combineTaskIntoExisting(
                              taskToAdd,
                              await DatabaseAccess.getInstance()
                                  .getStudentTasks());
                      DatabaseAccess.getInstance().addToDatabase(
                          "student tasks", "signed up", {"tasks": curTasks});

                      List<Map<String, dynamic>> allTaskMap =
                          StudentData.allViewingTask!;
                      // Remove task from existing
                      allTaskMap.removeAt(StudentData.viewingIndex!);
                      DatabaseAccess.getInstance().addToDatabase("Tasks",
                          StudentData.getQuerySubTeam(), {"tasks": allTaskMap});

                      ConfigUtils.goToScreen(HomeScreen(), context);
                    }
                  });
                },
                child: Text("Sign Up for task"),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
