import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/Sign_Up_Team_page.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Future<bool> isAdmin = StudentData.isAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        bottomNavigationBar: buildNavBar(context, 3),
        body: Center(
            child: Container(
          child: Column(children: [
            const SizedBox(height: 20),
            Text(
              "User email: ${StudentData.studentEmail}",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                  margin: const EdgeInsets.all(20.0),
                  child: FutureBuilder(
                      future: isAdmin,
                      builder: (context, isAdmin) {
                        if (!isAdmin.hasData) {
                          return Container();
                        } else {
                          if (isAdmin.data!) {
                            return createClickableIcon(
                                const Icon(Icons.groups,
                                    color: Colors.white, size: 30),
                                Color(0xFFFC7F7F), () {
                              ConfigUtils.goToScreen(
                                  const Signupteam_page(), context);
                            }, "Create a new team!");
                          } else {
                            return Container();
                          }
                        }
                      }))
            ]),
          ]),
        )));
  }
}
