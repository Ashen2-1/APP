import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/widgets/nav_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              )
            ]),
          ),
        ));
  }
}
