import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_up/constants/colors.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';

import '../services/file_uploader.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

import '../widgets/widgets.dart';

class Signupteam_page extends StatefulWidget {
  const Signupteam_page({Key? key}) : super(key: key);

  @override
  _Signupteam_pageState createState() => _Signupteam_pageState();
}

class _Signupteam_pageState extends State<Signupteam_page>
    with TickerProviderStateMixin {
  TextEditingController _teamnumberTextController = TextEditingController();
  TextEditingController _teamnameTextController = TextEditingController();
  TextEditingController _passcodeTextController = TextEditingController();

  late AnimationController controller;

  bool isPlaying = false;
  File? file;

  @override
  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const Signupteam_page());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(() {
      return mainLayout(context);
    }, context);
  }

  Scaffold mainLayout(BuildContext context) {
    return buildMainContent(context);
  }

  Scaffold buildMainContent(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(menuToggleExpansion,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.menu, color: tdBlack, size: 30),
                    onPressed: menuToggleExpansion),
                const Text(
                  "Sign Up for Your Team!",
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
            backgroundColor: const Color.fromARGB(231, 178, 34, 230)),
        backgroundColor: const Color.fromARGB(255, 201, 141, 141),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Team Channel!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "    Note: Team Channel Will have the same functions as the public channel but it only serve for the team members!",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                reusableTextField("Enter Team Number", Icons.person_outline,
                    false, _teamnumberTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Team Name", Icons.person_outline,
                    false, _teamnameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Pass Code", Icons.lock_clock_outlined,
                    true, _passcodeTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableButton("Upload a logo for the team", context, () async {
                  File result = (await FileUploader.pickFile())!;
                  setState(() {
                    file = result;
                    isPlaying = true;
                  });
                }),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async {
                    String fileURL = "None";
                    TaskSnapshot imageSnapshot =
                        await FileUploader.getInstance()
                            .addFileToFirebaseStorage(file!);
                    fileURL = await imageSnapshot.ref.getDownloadURL();
                    Map<String, dynamic> teamToAdd = {
                      'team number': _teamnumberTextController.text,
                      'team name': _teamnameTextController.text,
                      'team passcode': _passcodeTextController.text,
                      'team logo url': fileURL
                    };
                    DatabaseAccess.getInstance().addToDatabase(
                        "Teams", _teamnumberTextController.text, teamToAdd);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));

                    /// here we can Navigator to Team Channel!
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ));
  }
}
