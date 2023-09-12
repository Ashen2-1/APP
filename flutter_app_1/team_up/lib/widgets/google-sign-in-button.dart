import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/google_sign_in_auth.dart';

import '../constants/student_data.dart';
import '../services/database_access.dart';
import '../services/internet_connection.dart';
import 'reusable_widgets/reusable_widget.dart';
import 'student-mentor_popup.dart';

class GoogleSignInButton {
  static OutlinedButton googleSignInButton(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () async {
        User? user = await GoogleSignInAuth.signInWithGoogle(context: context);

        if (user != null && user.email != null) {
          FlutterLogs.logInfo("Google User Sign in", "User Email", user.email!);
          if (!(await connectedToInternet())) {
            displayError("You are not connected to the Internet", context);
          } else if (await DatabaseAccess.getInstance()
                  .getDocumentByID("student tasks", user.email!) ==
              null) {
            await showStudentMentorPopUp(context, false);
            DatabaseAccess.getInstance()
                .addToDatabase("student tasks", user.email!, {
              "isAdmin": StudentData.tempSignUpAdmin,
              "team number": 'Public',
              "normal team": "",
              "email": user.email!
            });
          }
          StudentData.studentEmail = user.email!;
          ConfigUtils.goToScreen(HomeScreen(), context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/google_logo.png"),
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
