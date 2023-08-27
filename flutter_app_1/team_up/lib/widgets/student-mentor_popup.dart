import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';

import '../screens/signup_screen.dart';

void showStudentMentorPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Wrap(
          //will break to another line on overflow
          direction: Axis.horizontal, //use vertical to show  on vertical axis
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),

            IconButton(
              icon: Image.asset('assets/images/Students.png'),
              iconSize: 160,
              onPressed: () {
                StudentData.tempSignUpAdmin = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
            ),
            const SizedBox(
              width: 5,
            ),

            IconButton(
              icon: Image.asset('assets/images/Mentor.png'),
              iconSize: 160,
              onPressed: () {
                StudentData.tempSignUpAdmin = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
            )

            // Add more buttons here
          ],
        ),
      );
    },
  );
}
