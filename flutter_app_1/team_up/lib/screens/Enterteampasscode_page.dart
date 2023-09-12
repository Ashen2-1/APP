import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/widgets/nav_bar.dart';

import '../constants/colors.dart';
import '../services/file_uploader.dart';
import '../services/internet_connection.dart';
import '../utils/configuration_util.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

import '../widgets/widgets.dart';

class Enterteampasscode_page extends StatefulWidget {
  const Enterteampasscode_page({Key? key}) : super(key: key);

  @override
  _Enterteampasscode_pageState createState() => _Enterteampasscode_pageState();
}

class _Enterteampasscode_pageState extends State<Enterteampasscode_page>
    with TickerProviderStateMixin {
  //TextEditingController _teamnameTextController = TextEditingController();
  TextEditingController _passcodeTextController = TextEditingController();

  late AnimationController controller;

  bool isPlaying = false;
  File? file;

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const Enterteampasscode_page());
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildNavBar(context, 2),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(231, 178, 34, 230),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.menu, color: tdBlack, size: 30),
                onPressed: menuToggleExpansion),
            const Text(
              "Join a team channel!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
      ),
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Text(
              "Team Channel!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "    Note: Team Channel Will have the same functions as the public channel but it only serve for the team members!",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Text("Signing up for team ${StudentData.signingUpTeamNumber}",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 25)),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Pass Code", Icons.lock_clock_outlined,
                true, _passcodeTextController),

            const SizedBox(
              height: 20,
            ),

            //reusableButton("Join the Team", context, () async {
            //Navigator.push(context,
            //MaterialPageRoute(builder: (context) => HomeScreen()));
            //}),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 19, 78, 218),
              ),
              onPressed: () async {
                if (!(await connectedToInternet())) {
                  displayError(
                      "You are not connected to the Internet", context);
                } else {
                  Map<String, dynamic>? team_data =
                      await DatabaseAccess.getInstance()
                          .getPotentialTeam(StudentData.signingUpTeamNumber);

                  FlutterLogs.logInfo(
                      "Sign up team", "Enter team", "$team_data");
                  if (_passcodeTextController.text ==
                      team_data!['team passcode']) {
                    StudentData.studentTeamNumber =
                        StudentData.signingUpTeamNumber;
                    Map<String, dynamic>? curStudentStats =
                        await DatabaseAccess.getInstance().getStudentStats();

                    curStudentStats ??= {};

                    FlutterLogs.logInfo(
                        "Add team", "curStudentStats", "$curStudentStats");

                    curStudentStats['team number'] =
                        StudentData.signingUpTeamNumber;

                    curStudentStats['normal team'] =
                        StudentData.signingUpTeamNumber;

                    DatabaseAccess.getInstance().addToDatabase("student tasks",
                        StudentData.studentEmail, curStudentStats);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    await displayError("Password is incorrect", context);
                  }
                }

                /// here we can Navigator to Team Channel!
              },
              child: Text("Join the Team"),
            ),
          ],
        ),
      ),
    );
  }
}
