import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import '../constants/student_data.dart';
import '../services/file_uploader.dart';
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

class _TaskDescription_pageState extends State<TaskDescription_page>
    with TickerProviderStateMixin {
  TextEditingController _teamnumberTextController = TextEditingController();
  TextEditingController _teamnameTextController = TextEditingController();
  TextEditingController _passcodeTextController = TextEditingController();
  int _time = -1;
  int _prev_time = -2;

  List<String> tasksList = [];
  List<String> dueDates = [];
  List<String> skillsNeeded = [];

  List<String> imageUrlList = [];

  List<String> description = [];

  //List<Image> resizedImageList = [];
  // List<Widget> taskBoxes = [];

  Future<void> addDynamicTaskFields(BuildContext context) async {
    List<Map<String, dynamic>>? queryResults =
        await DatabaseAccess.getInstance()
            .getAvailableTasks(_time, StudentData.getQuerySubTeam());

    FlutterLogs.logInfo(
        "MAINFRAME", "put widgets on screen", "query results: ${queryResults}");

    for (Map<String, dynamic> taskMap in queryResults!) {
      if (!Util.contains(taskMap['task'], tasksList)) {
        tasksList.add(taskMap['task']);
        dueDates.add(taskMap['due date']);
        skillsNeeded.add(taskMap['skills needed']);
        imageUrlList.add(taskMap['image url']);
        description.add(taskMap["description"]);
      }
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

  late AnimationController controller;

  bool isPlaying = false;
  File? file;

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
              height: 50,
            ),
            Center(
              child: Text(
                "Task Description: ${StudentData.currentDescrption}", ////${StudentData.currentDescrption!}, ${addDynamicTaskFields(context)}
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () async {
                ///// add the task to my task page
              },
              child: Text("Sign Up for task"),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: dueDates.length,
              itemBuilder: (context, index) {
                return textFieldTaskInfo(
                    tasksList[index],
                    dueDates[index],
                    skillsNeeded[index],
                    imageUrlList[index],
                    description[index],
                    true,
                    false,
                    context);
              },
            )),
          ],
        ),
      ),
    );
  }
}
