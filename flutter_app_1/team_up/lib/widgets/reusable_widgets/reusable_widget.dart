import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/borders.dart';
import 'package:team_up/constants/colors.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/Approve_page.dart';
import 'package:team_up/screens/all_approve_tasks_screen.dart';
import 'package:team_up/screens/countdown-page.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/widgets.dart';

import '../../screens/TaskDescription_page.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

SizedBox reusableTextFieldRegular(
    String text, TextEditingController controller, bool isStatusLabel) {
  return SizedBox(
    height: isStatusLabel ? 20.0 : 50.0,
    child: TextField(
      controller: controller,
      cursorColor: Colors.black87,
      style: TextStyle(color: Colors.black87.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.black87.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: isStatusLabel
            ? tdBGColor
            : const Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: isStatusLabel
                ? BorderRadius.circular(10.0)
                : BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
    ),
  );
}

Future<bool?> askConfirmation(BuildContext context, String taskText) async {
  bool? confirmation;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
            'Are you sure you want to assign yourself $taskText? This means you are starting the task right away'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Return false when "No" is pressed
              confirmation = false;
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return true when "Yes" is pressed
              confirmation = true;
            },
          ),
        ],
      );
    },
  );
  return confirmation;
}

Widget createClickableIcon(
    Icon icon, Color iconColor, void Function()? onTap, String text) {
  return Column(children: [
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: iconColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon,
        ),
      ),
    ),
    const SizedBox(
      height: 10,
    ),
    Text(
      //sub textsa colors
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.7),
      ),
    )
  ]);
}

String removeFireBaseBrackets(String error_string) {
  // Objective: remove firebase error type -- don't want user to see
  // \[ part means to find and remove occurence of [
  // [^\]]+ is to capture any filler characters inside the []
  // \] removes the close ], space is for formatting
  RegExp pattern = RegExp(r'\[[^\]]+\] ');
  return error_string.replaceAll(pattern, "");
}

Future<void> displayError(Object error, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(removeFireBaseBrackets(error.toString())),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return false when "No" is pressed
            },
          ),
        ],
      );
    },
  );
}

Future<void> displayAlert(Object error, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(removeFireBaseBrackets(error.toString())),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return false when "No" is pressed
            },
          ),
        ],
      );
    },
  );
}

Future<void> displayErrorFromString(String error, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return false when "No" is pressed
            },
          ),
        ],
      );
    },
  );
}

Future<bool> isMachineAvailable(machine) async {
  String? machineNeeded = await DatabaseAccess.getInstance()
      .getField("Machines", "Occupied", machine);
  return (machineNeeded != null &&
      machineNeeded != StudentData.studentEmail &&
      machineNeeded != "");
}

SizedBox textFieldTaskInfo(List<Map<String, dynamic>> allTaskMap,
    String subteam, int index, String incomingPage, BuildContext context) {
  Color color = const Color.fromARGB(255, 193, 184, 184).withOpacity(0.3);
  if (allTaskMap[index]['level'] == "Introductory") {
    color = easyColor;
  } else if (allTaskMap[index]['level'] == "Comfortable with skill") {
    color = mediumColor;
  } else if (allTaskMap[index]['level'] == "Experienced") {
    color = hardColor;
  }
  return SizedBox(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
          height: 120.0,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(10.0),
          //width: 200.0, //MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
              color:
                  color, //Color.fromARGB(255, 193, 184, 184).withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: ListView(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                regularText(allTaskMap[index]['task'], context, true),
                regularText(
                    "Due date:\n${Util.formatDateTime(allTaskMap[index]['due date'].toDate())}",
                    context,
                    false),
                regularText(
                    "Skills needed: ${allTaskMap[index]['skills needed']}",
                    context,
                    false),
                const SizedBox(height: 5),
                regularText("Task time: ${allTaskMap[index]['estimated time']}",
                    context, false),
                ////////////////////////////////////////////////new

                ElevatedButton(
                  onPressed: () {
                    StudentData.setViewingTask(allTaskMap);
                    StudentData.viewingIndex = index;
                    StudentData.descriptionIncomingPage = incomingPage;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TaskDescription_page()));

                    ///TaskDescription_page
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text("Description"),
                ),
                //////////////////////////////////////// Task Descriptions
                reusableSignUpTaskButton("Sign up for task", context, () {
                  askConfirmation(context, allTaskMap[index]['task'])
                      .then((confirmation) async {
                    if (confirmation != null && confirmation) {
                      if (allTaskMap[index]['machine needed'] != null &&
                          await isMachineAvailable(
                              allTaskMap[index]['machine needed'])) {
                        displayError(
                            "This machine is not available, can't sign up and work on it",
                            context);
                      } else {
                        Util.logAttendance();
                        //DatabaseAccess.getInstance().addToDatabase("Attendance", , data)
                        FlutterLogs.logInfo("TASK FIELD", "Sign up button",
                            "Adding ${allTaskMap[index]['task']}");
                        Map<String, dynamic> taskToAdd = allTaskMap[index];
                        taskToAdd['completer'] = StudentData.studentEmail;
                        taskToAdd['completed'] = false;
                        taskToAdd['approved'] = false;
                        taskToAdd['feedback'] = "None";
                        taskToAdd['complete percentage'] = "None";
                        taskToAdd['finish time'] = Timestamp.fromDate(
                            DateTime.now().add(Duration(
                                minutes: Util.convertStringTimeToIntMinutes(
                                    taskToAdd['estimated time']))));
                        List<Map<String, dynamic>>? inDatabaseTasks =
                            await DatabaseAccess.getInstance()
                                .getAllTasks(StudentData.getQuerySubTeam());
                        if (inDatabaseTasks!.isNotEmpty &&
                            inDatabaseTasks.length > index) {
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
                          allTaskMap.removeAt(index);
                          DatabaseAccess.getInstance().addToDatabase(
                              "Tasks", subteam, {"tasks": allTaskMap});

                          // Add machine to occupied database list
                          if (taskToAdd['machine needed'] != null) {
                            String machineOccupied =
                                taskToAdd['machine needed'];
                            DatabaseAccess.getInstance().addToDatabase(
                                "Machines",
                                "Occupied",
                                {machineOccupied: StudentData.studentEmail});
                          }

                          StudentData.currentTask = taskToAdd;
                          ConfigUtils.goToScreen(
                              const CountdownPage(), context);
                        } else {
                          await displayError(
                              "This task has all ready been taken", context);
                        }
                      }
                    }
                  });
                })
              ]),
              const SizedBox(width: 10.0), // For spacing
              if (allTaskMap[index]['image url'] != "None")
                Flexible(child: Image.network(allTaskMap[index]['image url'])),
            ]),
          ])));
  //////////////////////////////////////////////////////////////////////new
}

Future<SizedBox> studentTaskInfoWidget(
    List<Map<String, dynamic>> studentTasksMap,
    int index,
    BuildContext context) async {
  List<Map<String, dynamic>>? curTasksList =
      await DatabaseAccess.getInstance().getAllSignedUpTasks();

  Map<String, dynamic> curTask = curTasksList![index];
  Color color = const Color.fromARGB(255, 193, 184, 184).withOpacity(0.3);
  if (curTask['finish time'].seconds - Timestamp.now().seconds <= (30 * 60) &&
          curTask['finish time'].seconds - Timestamp.now().seconds > 0 ||
      curTask['due date'].seconds - Timestamp.now().seconds <=
              (1 * 24 * 60 * 60) &&
          curTask['due date'].seconds - Timestamp.now().seconds > 0) {
    color = const Color.fromARGB(255, 249, 94, 94).withOpacity(0.3);
  } else if (curTask['complete percentage'] == "100%") {
    color = Color.fromARGB(255, 27, 239, 73).withOpacity(0.6);
  } else if (curTask['approved'] &&
      (curTask['finish time'] == null ||
          curTask['finish time'].seconds > Timestamp.now().seconds)) {
    color = Color.fromARGB(255, 238, 200, 33).withOpacity(0.5);
  }

  return SizedBox(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
          height: 120.0,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(10.0),
          //width: 200.0, //MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: ListView(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                regularText(curTask['task'], context, true),
                const SizedBox(height: 3),
                regularText(
                    "Due date:\n${Util.formatDateTime(curTask['due date'].toDate())}",
                    context,
                    false),
                const SizedBox(height: 10),
                regularText("Skills needed: ${curTask['skills needed']}",
                    context, false),
                //const SizedBox(height: 3),
                regularText(
                    "Task time: ${curTask['estimated time']}", context, false),
                if (curTask['approved'])
                  if (curTask['feedback'] != "None")
                    regularText(
                        "Feedback: ${curTask['feedback']}", context, false),
                if (curTask['complete percentage'] != "None")
                  regularText(
                      "Complete percentage: ${curTask['complete percentage']}",
                      context,
                      false),
                ////////////////////////////////////////////////new
                ElevatedButton(
                  onPressed: () {
                    StudentData.setViewingTask(studentTasksMap);
                    StudentData.viewingIndex = index;
                    StudentData.descriptionIncomingPage = "my tasks";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TaskDescription_page()));

                    ///TaskDescription_page
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text("Description"),
                ),
                if (curTask['complete percentage'] == "100%")
                  reusableSignUpTaskButton("Clear this task", context, () {
                    studentTasksMap.removeAt(index);
                    DatabaseAccess.getInstance().addToDatabase("student tasks",
                        "signed up", {'tasks': studentTasksMap});
                    ConfigUtils.goToScreen(const HomeScreen(), context);
                  }),
                if (curTask['complete percentage'] != "100%" &&
                    curTask['approved'] &&
                    (curTask['finish time'] == null ||
                        Timestamp.now().seconds <
                            curTask['finish time'].seconds))
                  reusableSignUpTaskButton("Work on this task", context,
                      () async {
                    // FlutterLogs.logInfo("Sign up task", "Machine available",
                    //     curTask['machine needed']);
                    // FlutterLogs.logInfo("Sign up task", "Machine available",
                    //     "Status: ${!(await DatabaseAccess.getInstance().getField("Machines", "Occupied", curTask['machine needed']))}");
                    if (curTask['machine needed'] != null &&
                        await isMachineAvailable(curTask['machine needed'])) {
                      displayError(
                          "The machine is currently occupied", context);
                    } else {
                      Util.logAttendance();
                      StudentData.currentTask = curTask;

                      if (curTask['machine needed'] != null) {
                        DatabaseAccess.getInstance().updateField(
                            "Machines", "Occupied", {
                          curTask['machine needed']: StudentData.studentEmail
                        });
                      }

                      if (curTask['finish time'] == null) {
                        StudentData.currentTask!['finish time'] =
                            Timestamp.fromDate(DateTime.now().add(Duration(
                                minutes: Util.convertStringTimeToIntMinutes(
                                    curTask['estimated time']))));
                      }

                      DatabaseAccess.getInstance()
                          .addToDatabase("student tasks", "signed up", {
                        "tasks": Util.matchAndCombineExisting(
                            StudentData.currentTask!,
                            await DatabaseAccess.getInstance()
                                .getAllSignedUpTasks())
                      });
                      ConfigUtils.goToScreen(const CountdownPage(), context);
                    }
                  }),
              ]),
              const SizedBox(width: 10.0), // For spacing
              if (curTask['image url'] != "None")
                Flexible(child: Image.network(curTask['image url'])),
            ]),
          ])));
}

SizedBox regularText(String text, BuildContext context, bool isTitle) {
  return SizedBox(
    height: 30.0,
    width: 200.0,
    //(MediaQuery.of(context).size.width / 100),
    child: Text(
      // style: TextStyle(color: Colors.black87.withOpacity(0.9)),
      text, // Pass as parameter for the display text
      selectionColor: isTitle ? Colors.black87 : Colors.black54,
      textScaleFactor: isTitle ? 1.5 : 1.0,
    ),
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? "LOG IN" : "SIGN UP",
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

AppBar buildAppBar(void Function()? toggleExtended,
    {Color backgroundColor = tdBGColor, Widget? title}) {
  return AppBar(
    backgroundColor: backgroundColor,
    elevation: 0,
    title: title ??
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.menu, color: tdBlack, size: 30),
                onPressed: toggleExtended),
            Container(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset("assets/images/avatar.jpeg"),
              ),
            ),
          ],
        ),
  );
}
