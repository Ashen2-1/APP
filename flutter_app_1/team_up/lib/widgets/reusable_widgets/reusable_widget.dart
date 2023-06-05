import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/colors.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/widgets.dart';

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
            : Color.fromARGB(255, 199, 196, 196).withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: isStatusLabel
                ? BorderRadius.circular(10.0)
                : BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
    ),
  );
}

Future<bool?> _askConfirmation(BuildContext context, String taskText) async {
  bool? confirmation;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure you want to proceed?'),
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

Container textFieldTaskInfo(String taskText, String dueDateText,
    String instructionsText, bool isSignUp, BuildContext context) {
  return Container(
      height: 100.0,
      //width: 200.0, //MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //   color: Color.fromARGB(255, 193, 184, 184).withOpacity(0.3),
      //   shape: BoxShape.circle,
      //   border: Border.all(
      //     color: Colors.black,
      //     width: 2,
      //   ),
      color: Color.fromARGB(255, 193, 184, 184).withOpacity(0.3),
      child: ListView(children: [
        regularText(taskText, context, true),
        regularText(dueDateText, context, false),
        regularText(instructionsText, context, false),
        if (isSignUp)
          reusableButton("Sign up for task", context, () {
            _askConfirmation(context, taskText).then((confirmation) async {
              if (confirmation != null && confirmation) {
                FlutterLogs.logInfo(
                    "TASK FIELD", "Sign up button", "Adding $taskText");
                List<Map<String, dynamic>>? prevTasks =
                    await DatabaseAccess.getInstance().getStudentTasks();
                Map<String, dynamic> taskToAdd = {
                  "task": taskText,
                  "due date": dueDateText,
                  "skills needed": instructionsText
                };
                if (prevTasks != null) {
                  prevTasks.add(taskToAdd);
                } else {
                  prevTasks = [taskToAdd];
                }
                DatabaseAccess.getInstance().addToDatabase(
                    "student tasks", "Eric", {"tasks": prevTasks});
              }
            });
          })
      ]));
}

SizedBox regularText(String text, BuildContext context, bool isTitle) {
  return SizedBox(
    height: 30.0,
    //width: MediaQuery.of(context).size.width -
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
