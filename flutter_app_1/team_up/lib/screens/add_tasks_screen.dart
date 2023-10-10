import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/borders.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/services/file_uploader.dart';
import 'package:team_up/services/internet_connection.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../constants/colors.dart';
import '../constants/constants.dart';
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

  bool _isExpanded = false;

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
  String time = 'Select a time for task';
  String machineUsed = 'What equipment is used?';
  String level = "Select a level";
  bool isForAll = false;
  String imageURL = "None";

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
    time = 'Select a time for task';
    machineUsed = "What equipment is used?";
    level = "Select a level";
    imageURL = "";
    isForAll = false;
    day = DateTime.now().add(const Duration(minutes: 30));
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
      appBar: AppBar(
        title: const Text("Add a task"),
      ),
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

        const SizedBox(height: 28.0),
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
        // reusableTextFieldRegular(
        //     "Enter Specific Task", _taskTextController, false),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            maxLength: 15,
            controller: _taskTextController,
            cursorColor: Colors.black87,
            style: TextStyle(color: Colors.black87.withOpacity(0.9)),
            decoration: InputDecoration(
              labelText: "Enter Specific Task",
              labelStyle: TextStyle(color: Colors.black87.withOpacity(0.9)),
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor:
                  const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text("Selected Due Date: ${Util.formatDateTime(day)}"),
        const SizedBox(height: 8),
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
        reusableTextFieldRegular("Enter the description of the task",
            _taskdescriptionTextController, false),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width - 25,
            decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
                borderRadius: Borders.imageBorderRadius),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<String>(
                    value: time,
                    // hint: const Text("Select subteam:",
                    //     style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                    onChanged: (String? newValue) {
                      setState(() {
                        time = newValue!;
                      });
                    },
                    items: timeList
                        .map<DropdownMenuItem<String>>((String newValue) {
                      return DropdownMenuItem<String>(
                          value: newValue, child: Text(newValue));
                    }).toList()))),
        ///////////////////////////////////////////////// new
        if (subteam == "Build")
          Column(children: [
            const SizedBox(height: 10),
            Container(
                width: MediaQuery.of(context).size.width - 25,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 199, 196, 196)
                        .withOpacity(0.3),
                    borderRadius: Borders.imageBorderRadius),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        }).toList())))
          ]),
        const SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width - 25,
            decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
                borderRadius: Borders.imageBorderRadius),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<String>(
                    value: level,
                    onChanged: (String? newValue) {
                      setState(() {
                        level = newValue!;
                      });
                    },
                    items: levelList
                        .map<DropdownMenuItem<String>>((String newValue) {
                      return DropdownMenuItem<String>(
                          value: newValue, child: Text(newValue));
                    }).toList()))),
        const SizedBox(height: 10),
        Row(children: [
          const SizedBox(width: 5),
          Checkbox(
              value: isForAll,
              onChanged: (bool? value) {
                setState(() {
                  isForAll = value!;
                });
              }),
          const Text("Is this a task for everyone in subteam?",
              style: TextStyle(fontSize: 17)),
        ]),
        ///////////////////////////////////////////////////// Task description
        reusableButton("Upload a image related to task", context, () async {
          FilePickerResult? result =
              (await FilePicker.platform.pickFiles(allowMultiple: false));

          if (result != null) {
            // if (result.files.length > 1) {
            //   displayError("Only 1 image can be attached", context);
            // } else {
            PlatformFile file = result.files[0];
            String fileType = file.extension!;

            if (fileType == "png" || fileType == 'jpg' || fileType == 'jpeg') {
              if (!(await connectedToInternet())) {
                displayError("You are not connected to the Internet", context);
              } else {
                TaskSnapshot imageSnapshot = await FileUploader.getInstance()
                    .addFileToFirebaseStorage(file.name, file.bytes);
                imageURL = await imageSnapshot.ref.getDownloadURL();
                //FlutterLogs.logInfo(
//"Add to Database", "Upload image", "Image URL: $imageURL");

                fileInitialized = true;
                setState(() {});
              }
            } else {
              displayError("Invalid file type selected (image only)", context);
            }
            //}
          }
        }),
        if (fileInitialized) Image.network(imageURL),
        reusableButton("ADD TO DATABASE", context, () async {
          if (subteam != 'Select a subteam' &&
              time != 'Select a time for task' &&
              (subteam != "Build" ||
                  machineUsed != "What equipment is used?") &&
              level != "Select a level" &&
              _taskTextController.text != "") {
            Map<String, dynamic> taskToAdd = {
              "task": _taskTextController.text,
              ///////////////////////////////////new
              "description": _taskdescriptionTextController.text,
              //////////////////////////////////// task description
              "estimated time": time,
              "due date": day,
              "skills needed": _skillsRequiredController.text,
              "image url": imageURL,
              'assigner': StudentData.studentEmail,
              'feedback': "None",
              'complete percentage': "None",
              'level': level,
              'isForAll': isForAll,
              'team number': await StudentData.getStudentTeamNumber(),
            };

            if (machineUsed != "What equipment is used?") {
              taskToAdd['machine needed'] = machineUsed;
            }
            List<Map<String, dynamic>> curTasks =
                await Util.combineTaskIntoExisting(taskToAdd,
                    await DatabaseAccess.getInstance().getAllTasks(subteam));

            DatabaseAccess.getInstance()
                .addToDatabase("Tasks", subteam, {"tasks": curTasks});

            Util.addToLog(
                "${StudentData.studentEmail} added a task ${taskToAdd['task']}");
            clearFields();
            displayAlert("Successfully submitted!", context);
          } else {
            displayError("A field was not filled out", context);
          }
        }),
      ],
    ));
  }

  void goToProgress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StudentProgressScreen()));
  }
}
