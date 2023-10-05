import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/tasks_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../constants/student_data.dart';
import '../utils/util.dart';
import 'Approve_page.dart';

class UnassignedTasksPage extends StatefulWidget {
  const UnassignedTasksPage({Key? key}) : super(key: key);

  @override
  State<UnassignedTasksPage> createState() => _UnassignedTasksPageState();
}

class _UnassignedTasksPageState extends State<UnassignedTasksPage> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap = [];
  //List<String> task = [];

  List<String> studentTasks = [];
  List<String> imageURL = [];

  Future<void> configure() async {
    studentTasksMap = await DatabaseAccess.getInstance().getUnassignedTasks();
    FlutterLogs.logInfo(
        "My Tasks", "Add to ListView", "studentTasksMap: ${studentTasksMap}");
    setState(() {});
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const UnassignedTasksPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(title: Text("Unassigned Tasks")),
      bottomNavigationBar: buildNavBar(context, 1),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return FutureBuilder(
        future: DatabaseAccess.getInstance().getUnassignedTasks(),
        builder: (context, unassigned) {
          if (!unassigned.hasData) {
            return Container();
          }
          studentTasksMap = unassigned.data;
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: studentTasksMap!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 177, 167, 167)
                                    .withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Row(children: [
                              Column(children: [
                                regularText(studentTasksMap![index]['task'],
                                    context, true),
                                reusableSignUpTaskButton(
                                    "Resend this task", context, () async {
                                  DateTime? dateTime = await showDatePicker(
                                      context: context,
                                      helpText: "SELECT A NEW DUE DATE",
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.utc(9999, 08, 16));

                                  final TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());

                                  if (dateTime != null && time != null) {
                                    dateTime = dateTime.add(Duration(
                                        hours: time.hour,
                                        minutes: time.minute));
                                  }

                                  if (dateTime != null) {
                                    studentTasksMap![index]['due date'] =
                                        dateTime;
                                    List<dynamic> databaseGet =
                                        await DatabaseAccess.getInstance()
                                            .getField(
                                                "Tasks",
                                                studentTasksMap![index]
                                                    ['subteam'],
                                                "tasks");
                                    DatabaseAccess.getInstance().addToDatabase(
                                        "Tasks",
                                        studentTasksMap![index]['subteam'], {
                                      "tasks": Util.combineTaskIntoExisting(
                                          studentTasksMap![index],
                                          databaseGet
                                              .cast<Map<String, dynamic>>())
                                    });
                                    await Util.addToLog(
                                        "${StudentData.studentEmail} redistributed task ${studentTasksMap![index]['task']}");

                                    studentTasksMap!.removeAt(index);
                                    DatabaseAccess.getInstance().addToDatabase(
                                        "Tasks",
                                        "outstanding",
                                        {"tasks": studentTasksMap});

                                    studentTasksMap =
                                        await DatabaseAccess.getInstance()
                                            .getUnassignedTasks();

                                    setState(() {});
                                  } else {
                                    displayError(
                                        "Did not resend, please press ok after selecting date/time",
                                        context);
                                  }
                                }),
                                reusableSignUpTaskButton(
                                    "Remove tracking", context, () async {
                                  studentTasksMap!.removeAt(index);
                                  DatabaseAccess.getInstance().addToDatabase(
                                      "Tasks",
                                      "outstanding",
                                      {"tasks": studentTasksMap});
                                  await Util.addToLog(
                                      "${StudentData.studentEmail} removed unassigned task ${studentTasksMap![index]['task']}");
                                })
                              ]),
                              // if (imageURL[index] != "None")
                              //   Expanded(child: Image.network(imageURL[index]))
                            ]));
                      })),
              reusableButton("Update unassigned tasks", context, () async {
                configure();
              }),
            ],
          );
        });
  }
}
