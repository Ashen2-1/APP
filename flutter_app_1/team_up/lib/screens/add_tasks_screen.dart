import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/borders.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/services/file_uploader.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../constants/colors.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';
import 'package:team_up/services/database_access.dart';

class AddTasksScreen extends StatefulWidget {
  const AddTasksScreen({Key? key}) : super(key: key);

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  final TextEditingController _taskTextController = TextEditingController();
  final TextEditingController _dueDateTextController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _taskdescriptionTextController =
      TextEditingController();

  final TextEditingController _submissionController = TextEditingController();

  bool _isExpanded = false;

  File? file;
  bool fileInitialized = false;

  final List<String> subteamList = [
    'Select a subteam',
    'Build',
    'Programming',
    'Design',
    'Media',
    "Outreach",
    "Business"
  ];

  List<TextEditingController>? controllerList;

  final List<String> timeList = [
    'Select an amount of time for task completion',
    '10 minutes',
    '20 minutes',
    '30 minutes',
    '40 minutes',
    '1 hour',
    '1 and 1/2 hour',
    '2 hours'
  ];

  final List<String> machineList = [
    "What equipment is used?",
    "Band Saw",
    "Conventional Lathe",
    "Drill Press",
    "CNC router",
    "vertical milling machine",
    "grinder",
    "arbour press",
    "belt and disk sander",
    "cut-off saw",
    "Cordless pop riveter",
    "cordless drill",
    "cordless reciprocating saw",
    "surface plate",
    "3D printer",
    "None"
  ];

  final List<String> levelList = [
    "Select a level",
    "Introductory",
    "Comfortable with skill",
    "Experienced"
  ];

  DateTime day = DateTime.now().add(const Duration(minutes: 30));

  DateTime now = DateTime.now();

  String subteam = 'Select a subteam';
  String time = 'Select an amount of time for task completion';
  String machineUsed = 'What equipment is used?';
  String level = "Select a level";

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const AddTasksScreen());
    });
  }

  void clearFields() {
    for (TextEditingController controller in controllerList!) {
      controller.clear();
    }
    subteam = 'Select a subteam';
    time = 'Select an amount of time for task completion';
    machineUsed = "What equipment is used?";
    level = "Select a level";
    setState(() {
      fileInitialized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(
        () => mainLayout(context), context);
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      //appBar: buildAppBar(menuToggleExpansion),
      
      bottomNavigationBar: buildNavBar(context, 1),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    controllerList = [
      _taskTextController,
      _dueDateTextController,
      _skillsRequiredController,
      _taskdescriptionTextController
    ];
    //subteamList.add("Select subteam:");

    return SingleChildScrollView(
        child: Column(
      children: [
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 15),
        //   decoration: BoxDecoration(
        //       color: Colors.white, borderRadius: BorderRadius.circular(20)),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.all(0),
        //       prefixIcon: Icon(
        //         Icons.search,
        //         color: tdBlack,
        //         size: 20,
        //       ),
        //       prefixIconConstraints:
        //           BoxConstraints(maxHeight: 20, minWidth: 25),
        //       border: InputBorder.none,
        //       hintText: "Search",
        //       hintStyle: TextStyle(color: tdGrey),
        //     ),
        //   ),
        // ),
        SizedBox(height: 35,),
        const Text("Add a task!",
            style: TextStyle(fontSize: 30, decorationThickness: 1.5)),
        const SizedBox(height: 10.0),
        Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
              borderRadius: Borders.imageBorderRadius),
          child: DropdownButton<String>(
              value: subteam,
              // hint: const Text("Select subteam:",
              //     style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
              onChanged: (String? newValue) {
                setState(() {
                  subteam = newValue!;
                });
              },
              items:
                  subteamList.map<DropdownMenuItem<String>>((String newValue) {
                return DropdownMenuItem<String>(
                    value: newValue, child: Text(newValue));
              }).toList()),
        ),
        const SizedBox(height: 10.0),
        reusableTextFieldRegular(
            "Enter Specific Task", _taskTextController, false),
        const SizedBox(height: 10),
        Text("Selected Due Date: ${Util.formatDateTime(day)}"),
        ElevatedButton(
            onPressed: () async {
              DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: day,
                  firstDate: now,
                  lastDate: DateTime.utc(9999, 08, 16));

              final TimeOfDay? time = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

              if (dateTime != null && time != null) {
                dateTime = dateTime
                    .add(Duration(hours: time.hour, minutes: time.minute));
              }

              if (dateTime != null) {
                setState(() {
                  day = dateTime!;
                });
              }
            },
            child: const Text("Select a due date")),
        const SizedBox(height: 10),
        reusableTextFieldRegular(
            "Enter skills required for task", _skillsRequiredController, false),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
                borderRadius: Borders.imageBorderRadius),
            child: DropdownButton<String>(
                value: time,
                // hint: const Text("Select subteam:",
                //     style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                onChanged: (String? newValue) {
                  setState(() {
                    time = newValue!;
                  });
                },
                items:
                    timeList.map<DropdownMenuItem<String>>((String newValue) {
                  return DropdownMenuItem<String>(
                      value: newValue, child: Text(newValue));
                }).toList())),
        const SizedBox(height: 10),
        ///////////////////////////////////////////////// new
        reusableTextFieldRegular("Enter the description of the task",
            _taskdescriptionTextController, false),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
                borderRadius: Borders.imageBorderRadius),
            child: DropdownButton<String>(
                value: machineUsed,
                onChanged: (String? newValue) {
                  setState(() {
                    machineUsed = newValue!;
                  });
                },
                items: machineList
                    .map<DropdownMenuItem<String>>((String newValue) {
                  return DropdownMenuItem<String>(
                      value: newValue, child: Text(newValue));
                }).toList())),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
                borderRadius: Borders.imageBorderRadius),
            child: DropdownButton<String>(
                value: level,
                onChanged: (String? newValue) {
                  setState(() {
                    level = newValue!;
                  });
                },
                items:
                    levelList.map<DropdownMenuItem<String>>((String newValue) {
                  return DropdownMenuItem<String>(
                      value: newValue, child: Text(newValue));
                }).toList())),
        ///////////////////////////////////////////////////// Task description
        reusableButton("Upload a image related to task", context, () async {
          File result = (await FileUploader.pickFile())!;
          setState(() {
            String fileType = result.path.split(".").last.toLowerCase();
            if (fileType == "png" || fileType == 'jpg' || fileType == 'jpeg') {
              file = result;
              fileInitialized = true;
            } else {
              displayError("Invalid file type selected", context);
            }
          });
        }),
        if (fileInitialized && file != null) Image.file(file!),
        reusableButton("ADD TO DATABASE", context, () async {
          String imageURL = "None";
          if (file != null) {
            TaskSnapshot imageSnapshot = await FileUploader.getInstance()
                .addFileToFirebaseStorage(file!);
            imageURL = await imageSnapshot.ref.getDownloadURL();
            FlutterLogs.logInfo(
                "Add to Database", "Upload image", "Image URL: $imageURL");
          }
          if (subteam != 'Select a subteam' &&
              time != 'Select an amount of time for task completion' &&
              machineUsed != "What equipment is used?" &&
              level != "Select a level") {
            Map<String, dynamic> taskToAdd = {
              "task": _taskTextController.text,
              ///////////////////////////////////new
              "description": _taskdescriptionTextController.text,
              //////////////////////////////////// task description
              "estimated time": time,
              "due date": _dueDateTextController.text,
              "skills needed": _skillsRequiredController.text,
              "image url": imageURL,
              'assigner': StudentData.studentEmail,
              'feedback': "None",
              'complete percentage': "None",
              'machine needed': machineUsed,
              'level': level,
              'team number': await StudentData.getStudentTeamNumber(),
            };
            List<Map<String, dynamic>> curTasks =
                await Util.combineTaskIntoExisting(taskToAdd,
                    await DatabaseAccess.getInstance().getAllTasks(subteam));

            DatabaseAccess.getInstance()
                .addToDatabase("Tasks", subteam, {"tasks": curTasks});
            clearFields();
            _submissionController.text = "Submitted!";
          } else {
            displayError("A field was not filled out", context);
          }
        }),
        reusableTextFieldRegular("", _submissionController, true),
      ],
    ));
  }

  void goToProgress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StudentProgressScreen()));
  }
}
