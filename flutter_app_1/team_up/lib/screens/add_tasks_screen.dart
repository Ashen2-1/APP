import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/borders.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/services/file_uploader.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
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

  String subteam = 'Select a subteam';
  String time = 'Select an amount of time for task completion';

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
    setState(() {
      fileInitialized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
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
        reusableTextFieldRegular(
            "Enter due date for task", _dueDateTextController, false),
        const SizedBox(height: 10),
        reusableTextFieldRegular(
            "Enter skills required for task", _skillsRequiredController, false),
        const SizedBox(height: 10),
        Container(
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
        ///////////////////////////////////////////////////// Task description
        reusableButton("Upload a image related to task", context, () async {
          File result = (await FileUploader.pickFile())!;
          setState(() {
            if (file!.path.split(".").last.toLowerCase() == "png") {
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
              time != 'Select an amount of time for task completion') {
            Map<String, dynamic> taskToAdd = {
              "task": _taskTextController.text,
              ///////////////////////////////////new
              "description": _taskdescriptionTextController.text,
              //////////////////////////////////// task description
              "estimated time": time,
              "due date": _dueDateTextController.text,
              "skills needed": _skillsRequiredController.text,
              "image url": imageURL
            };
            List<Map<String, dynamic>> curTasks =
                await Util.combineTaskIntoExisting(
                    taskToAdd,
                    await DatabaseAccess.getInstance()
                        .getAllTasks(time, subteam));

            DatabaseAccess.getInstance()
                .addToDatabase("Tasks", subteam, {"tasks": curTasks});
            clearFields();
            _submissionController.text = "Submitted!";
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
