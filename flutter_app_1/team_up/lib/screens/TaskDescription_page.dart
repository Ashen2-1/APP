import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/web_view_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
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
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            Center(
              child: Text(
                "Task: ${StudentData.viewingTask!['task']}", ////${StudentData.currentDescrption!}, ${addDynamicTaskFields(context)}
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "Task Description: ${StudentData.viewingTask!['description']}",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "Task time: ${StudentData.viewingTask!['estimated time']}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            if (StudentData.viewingTask!['feedback'] != "None")
              Center(
                child: Text(
                  "Feedback: ${StudentData.viewingTask!['feedback']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            if (StudentData.viewingTask!['complete percentage'] != "None")
              Center(
                child: Text(
                  "Complete percentage: ${StudentData.viewingTask!['complete percentage']}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 25),
            if (StudentData.viewingTask!['image url'] != "None")
              Expanded(
                  child: Image.network(StudentData.viewingTask!['image url'])),
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
                  askConfirmation(context, StudentData.viewingTask!['task'])
                      .then((confirmation) async {
                    if (confirmation != null && confirmation) {
                      FlutterLogs.logInfo("TASK FIELD", "Sign up button",
                          "Adding ${StudentData.viewingTask!['task']}");
                      Map<String, dynamic> taskToAdd = StudentData.viewingTask!;
                      List<Map<String, dynamic>> curTasks =
                          await Util.combineTaskIntoExisting(
                              taskToAdd,
                              await DatabaseAccess.getInstance()
                                  .getStudentTasks());
                      DatabaseAccess.getInstance().addToDatabase(
                          "student tasks",
                          StudentData.studentEmail,
                          {"tasks": curTasks});
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
