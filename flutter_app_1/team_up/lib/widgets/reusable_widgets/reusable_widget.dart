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
        title: Text('Confirmation'),
        content: Text('Are you sure you want to assign yourself $taskText?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Return false when "No" is pressed
              confirmation = false;
            },
          ),
          TextButton(
            child: Text('Yes'),
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
        title: Text('Error'),
        content: Text(removeFireBaseBrackets(error.toString())),
        actions: [
          TextButton(
            child: Text('Ok'),
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
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            child: Text('Ok'),
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

SizedBox textFieldTaskInfo(
    String taskText,
    String dueDateText,
    String instructionsText,
    String imageUrl,
    String description,
    String taskTime,
    bool isSignUp,
    bool isAssignment,
    String incomingPage,
    BuildContext context) {
  return SizedBox(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
          height: 120.0,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(10.0),
          //width: 200.0, //MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
              color: Color.fromARGB(255, 193, 184, 184).withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: ListView(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                regularText(taskText, context, true),
                regularText("Due date: $dueDateText", context, false),
                regularText("Skills needed: $instructionsText", context, false),
                const SizedBox(height: 5),
                regularText("Task time: $taskTime", context, false),
                ////////////////////////////////////////////////new

                ElevatedButton(
                  onPressed: () {
                    StudentData.setViewingTask({
                      "task": taskText,
                      "due date": dueDateText,
                      "skills needed": instructionsText,
                      "image url": imageUrl,
                      "description": description
                    });
                    StudentData.descriptionIncomingPage = incomingPage;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDescription_page()));

                    ///TaskDescription_page
                  },
                  child: Text("Description"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                ),
                //////////////////////////////////////// Task Descriptions
                if (isSignUp /*&& Util.isTaskIn(taskText)*/)
                  reusableSignUpTaskButton("Sign up for task", context, () {
                    askConfirmation(context, taskText)
                        .then((confirmation) async {
                      if (confirmation != null && confirmation) {
                        FlutterLogs.logInfo(
                            "TASK FIELD", "Sign up button", "Adding $taskText");
                        Map<String, dynamic> taskToAdd = {
                          "task": taskText,
                          "due date": dueDateText,
                          "skills needed": instructionsText,
                          "image url": imageUrl,
                          "estimated time": taskTime,
                          "description": description,
                        };
                        List<Map<String, dynamic>> curTasks =
                            await Util.combineTaskIntoExisting(
                                taskToAdd,
                                await DatabaseAccess.getInstance()
                                    .getStudentTasks());
                        DatabaseAccess.getInstance().addToDatabase(
                            "student tasks",
                            StudentData.studentEmail,
                            {"tasks": curTasks});
                        // Update status of current tasks to reflect unavailable
                        //DatabaseAccess.getInstance().updateField("", docId, data)
                      }
                    });
                  })
                else if (isAssignment)
                  reusableSignUpTaskButton("START this task", context, () {
                    StudentData.currentTask = taskText;
                    StudentData.currentTaskTimeLimit = taskTime;
                    ConfigUtils.goToScreen(CountdownPage(), context);
                  })
              ]),
              const SizedBox(width: 10.0), // For spacing
              if (imageUrl != "None") Flexible(child: Image.network(imageUrl)),
            ]),
          ])));
  //////////////////////////////////////////////////////////////////////new
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
      child: Text(
        isLogin ? "LOG IN" : "SIGN UP",
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

AppBar buildAppBar(void Function()? toggleExtended) {
  return AppBar(
    backgroundColor: tdBGColor,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(Icons.menu, color: tdBlack, size: 30),
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
