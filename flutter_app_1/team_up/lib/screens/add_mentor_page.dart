import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/widgets/widgets.dart';

import '../constants/colors.dart';
import '../utils/configuration_util.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';

class AddMentorPage extends StatefulWidget {
  const AddMentorPage({Key? key}) : super(key: key);

  @override
  State<AddMentorPage> createState() => AddMentorPageState();
}

class AddMentorPageState extends State<AddMentorPage> {
  Future<bool> isAdmin = StudentData.isAdmin();
  final TextEditingController _mentorEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(() {
      return mainLayout(context);
    }, context);
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const AddMentorPage());
    });
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(context),
    );
  }

  Widget buildMainContent(BuildContext context) {
    return FutureBuilder(
      future: isAdmin,
      builder: (context, isAdmin) {
        if (!isAdmin.hasData) {
          return const Text("Data loading", style: TextStyle(fontSize: 20));
        } else {
          if (isAdmin.data!) {
            return Container(
              child: Column(
                children: [
                  regularText("Add a mentor", context, true),
                  reusableTextFieldRegular("Enter email to add that mentor",
                      _mentorEmailController, false),
                  reusableButton("Add mentor", context, () async {
                    String mentorTeamNum = "";
                    if (await DatabaseAccess.getInstance().getField(
                            "student tasks",
                            _mentorEmailController.text,
                            "team number") !=
                        null) {
                      mentorTeamNum = await DatabaseAccess.getInstance()
                          .getField("student tasks",
                              _mentorEmailController.text, "team number");

                      if (mentorTeamNum != "" &&
                          mentorTeamNum ==
                              await StudentData.getStudentTeamNumber()) {
                        DatabaseAccess.getInstance().updateField(
                            "student tasks",
                            _mentorEmailController.text,
                            {"isAdmin": true});
                        ConfigUtils.goToScreen(HomeScreen(), context);
                      } else {
                        await displayError(
                            "The mentor's team number does not match with yours",
                            context);
                      }
                    } else {
                      await displayError("This mentor does not exist", context);
                    }
                  })
                ],
              ),
            );
          } else {
            return const Text("You don't have access to this page",
                style: TextStyle(fontSize: 20));
          }
        }
      },
    );
  }
}
