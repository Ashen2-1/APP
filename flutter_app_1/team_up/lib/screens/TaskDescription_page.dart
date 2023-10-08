import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../services/internet_connection.dart';
import '../utils/fonts.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';
import 'countdown-page.dart';

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
          backgroundColor: const Color.fromARGB(231, 178, 34, 230),
          title: const Text(
            "Descriptions",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: buildNavBar(context, 1),
        backgroundColor: const Color.fromARGB(255, 201, 141, 141),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: StudentData.allViewingTask!.isNotEmpty
                  ? <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Task:\n ${StudentData.allViewingTask![StudentData.viewingIndex!]['task']}", ////${StudentData.currentDescrption!}, ${addDynamicTaskFields(context)}
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          "Task time: ${StudentData.allViewingTask![StudentData.viewingIndex!]['estimated time']}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          "Task Description:\n${StudentData.allViewingTask![StudentData.viewingIndex!]['description']}",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['finish time'] !=
                          null)
                        Column(children: [
                          Center(
                            child: Text(
                              "Time Due: ${Util.formatDateTime(StudentData.allViewingTask![StudentData.viewingIndex!]['finish time'].toDate())}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ]),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                                  ['machine needed'] !=
                              null &&
                          StudentData.allViewingTask![StudentData.viewingIndex!]
                                  ['machine needed'] !=
                              "What equipment is used?")
                        Column(children: [
                          Center(
                            child: Text(
                              "Machine Needed: ${StudentData.allViewingTask![StudentData.viewingIndex!]['machine needed']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ]),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['assigner'] !=
                          null)
                        Column(children: [
                          Center(
                            child: Text(
                              "Creator: ${StudentData.allViewingTask![StudentData.viewingIndex!]['assigner']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ]),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['completer'] !=
                          null)
                        Column(children: [
                          Center(
                            child: Text(
                              "Completer: ${StudentData.allViewingTask![StudentData.viewingIndex!]['completer']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ]),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['feedback'] !=
                          "None")
                        Column(children: [
                          Center(
                            child: Text(
                                "Feedback: ${StudentData.allViewingTask![StudentData.viewingIndex!]['feedback']}",
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 15),
                        ]),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['complete percentage'] !=
                          "None")
                        Column(children: [
                          Center(
                            child: Text(
                              "Complete percentage: ${StudentData.allViewingTask![StudentData.viewingIndex!]['complete percentage']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                      const SizedBox(height: 25),
                      if (StudentData.allViewingTask![StudentData.viewingIndex!]
                              ['image url'] !=
                          "None")
                        // Flexible(
                        //     child:
                        //         Stack(alignment: Alignment.center, children: [
                        SizedBox(
                            width: 300,
                            height: 300,
                            child:
                                // Flexible(
                                Image.network(
                                    StudentData.allViewingTask![
                                        StudentData.viewingIndex!]['image url'],
                                    fit: BoxFit.cover)),

                      const SizedBox(
                        height: 40,
                      ),
                      if (StudentData.descriptionIncomingPage == "search tasks")
                        reusableSignUpTaskButton("Sign up for task", context,
                            () {
                          askConfirmation(
                                  context,
                                  StudentData.allViewingTask![
                                      StudentData.viewingIndex!]['task'])
                              .then((confirmation) async {
                            if (confirmation != null && confirmation) {
                              if (StudentData.allViewingTask![StudentData
                                          .viewingIndex!]['machine needed'] !=
                                      null &&
                                  !(await isMachineAvailable(
                                      StudentData.allViewingTask![StudentData
                                          .viewingIndex!]['machine needed']))) {
                                displayError(
                                    "This machine is not available, can't sign up and work on it",
                                    context);
                              } else if (!(await connectedToInternet())) {
                                displayError(
                                    "You are not connected to the Internet",
                                    context);
                              } else {
                                Util.logAttendance();
                                //DatabaseAccess.getInstance().addToDatabase("Attendance", , data)
                                FlutterLogs.logInfo(
                                    "TASK FIELD",
                                    "Sign up button",
                                    "Adding ${StudentData.allViewingTask![StudentData.viewingIndex!]['task']}");
                                Map<String, dynamic> taskToAdd = StudentData
                                    .allViewingTask![StudentData.viewingIndex!];
                                taskToAdd['completer'] =
                                    StudentData.studentEmail;
                                taskToAdd['completed'] = false;
                                taskToAdd['approved'] = false;
                                taskToAdd['feedback'] = "None";
                                taskToAdd['complete percentage'] = "None";
                                taskToAdd['studentViewable'] = true;
                                taskToAdd['finish time'] = Timestamp.fromDate(
                                    DateTime.now().add(Duration(
                                        minutes:
                                            Util.convertStringTimeToIntMinutes(
                                                taskToAdd['estimated time']))));
                                taskToAdd['due date'] =
                                    taskToAdd['finish time'];
                                List<Map<String, dynamic>>? inDatabaseTasks =
                                    await DatabaseAccess.getInstance()
                                        .getAllTasks(
                                            StudentData.getQuerySubTeam());
                                if (inDatabaseTasks!.isNotEmpty &&
                                    inDatabaseTasks.length >
                                        StudentData.viewingIndex! &&
                                    inDatabaseTasks[StudentData.viewingIndex!]
                                            ['task'] ==
                                        StudentData.allViewingTask![StudentData
                                            .viewingIndex!]['task']) {
                                  List<Map<String, dynamic>> curTasks =
                                      await Util.combineTaskIntoExisting(
                                          taskToAdd,
                                          await DatabaseAccess.getInstance()
                                              .getAllSignedUpTasks());
                                  DatabaseAccess.getInstance().addToDatabase(
                                      "student tasks",
                                      "signed up",
                                      {"tasks": curTasks});

                                  // Remove task from existing
                                  if (!taskToAdd['isForAll']) {
                                    StudentData.allViewingTask!
                                        .removeAt(StudentData.viewingIndex!);
                                    DatabaseAccess.getInstance().addToDatabase(
                                        "Tasks",
                                        StudentData.getQuerySubTeam(),
                                        {"tasks": StudentData.allViewingTask!});
                                  }

                                  // Add machine to occupied database list
                                  if (taskToAdd['machine needed'] != null) {
                                    String machineOccupied =
                                        taskToAdd['machine needed'];
                                    DatabaseAccess.getInstance()
                                        .addToDatabase("Machines", "Occupied", {
                                      machineOccupied: [
                                        StudentData.studentEmail,
                                        taskToAdd['due date']
                                      ]
                                    });
                                  }

                                  await Util.addToLog(
                                      "${StudentData.studentEmail} signed up for task ${taskToAdd['task']}");

                                  StudentData.currentTask = taskToAdd;
                                  ConfigUtils.goToScreen(
                                      const CountdownPage(), context);
                                } else {
                                  await displayError(
                                      "This task has all ready been taken",
                                      context);
                                }
                              }
                            }
                          });
                        }),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     primary: Colors.green,
                      //   ),
                      //   onPressed: () async {
                      //     ///// add the task to my task page
                      //     askConfirmation(
                      //             context,
                      //             StudentData.allViewingTask![StudentData.viewingIndex!]
                      //                 ['task'])
                      //         .then((confirmation) async {
                      //       if (confirmation != null && confirmation) {
                      //         FlutterLogs.logInfo("TASK FIELD", "Sign up button",
                      //             "Adding ${StudentData.allViewingTask![StudentData.viewingIndex!]['task']}");
                      //         Map<String, dynamic> taskToAdd = StudentData
                      //             .allViewingTask![StudentData.viewingIndex!];
                      //         taskToAdd['completer'] = StudentData.studentEmail;
                      //         taskToAdd['completed'] = false;
                      //         taskToAdd['approved'] = false;
                      //         taskToAdd['feedback'] = "None";
                      //         taskToAdd['complete percentage'] = "None";
                      //         List<Map<String, dynamic>> curTasks =
                      //             await Util.combineTaskIntoExisting(
                      //                 taskToAdd,
                      //                 await DatabaseAccess.getInstance()
                      //                     .getStudentTasks());
                      //         DatabaseAccess.getInstance().addToDatabase(
                      //             "student tasks", "signed up", {"tasks": curTasks});

                      //         List<Map<String, dynamic>> allTaskMap =
                      //             StudentData.allViewingTask!;
                      //         // Remove task from existing
                      //         allTaskMap.removeAt(StudentData.viewingIndex!);
                      //         DatabaseAccess.getInstance().addToDatabase("Tasks",
                      //             StudentData.getQuerySubTeam(), {"tasks": allTaskMap});

                      //         ConfigUtils.goToScreen(HomeScreen(), context);
                      //       }
                      //     });
                      //   },
                      //   child: Text("Sign Up for task"),
                      // ),
                      const SizedBox(height: 20),
                    ]
                  : [],
            ),
          ),
        ));
  }
}
