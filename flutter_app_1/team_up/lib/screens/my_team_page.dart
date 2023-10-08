import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/calendar.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/Jointeam_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/widgets.dart';

import 'member_details_page.dart';

class MyTeamPage extends StatefulWidget {
  const MyTeamPage({super.key});

  @override
  State<MyTeamPage> createState() => MyTeamPageState();
}

class MyTeamPageState extends State<MyTeamPage> {
  Future<dynamic> studentTeamNumber = DatabaseAccess.getInstance()
      .getField("student tasks", StudentData.studentEmail, "team number");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: studentTeamNumber,
        builder: (context, studentTeamNumber) {
          if (!studentTeamNumber.hasData) {
            return Container();
          }
          return FutureBuilder(
              future: DatabaseAccess.getInstance().getField(
                  "student tasks", StudentData.studentEmail, "normal team"),
              builder: (context, normal_team) {
                if (!normal_team.hasData) {
                  return Container();
                } else if (normal_team.data == "") {
                  return const Jointeam_page();
                }
                return buildTeamList(context, studentTeamNumber.data);
              });
        });
  }

  Scaffold buildTeamList(context, String teamNumber) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My team"),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: buildNavBar(context, 2),
        body: _buildListView(context, teamNumber));
  }

  Widget _buildListView(BuildContext context, String teamNumber) {
    return Column(children: [
      FutureBuilder(
          future: StudentData.isAdmin(),
          builder: (context, isAdmin) {
            if (!isAdmin.hasData) {
              return Container();
            } else if (isAdmin.data!) {
              return reusableButton("Check Full Attendance", context, () {
                StudentData.viewingOwnAttendance = false;
                ConfigUtils.goToScreen(const AttendanceScreen(), context);
              });
            }
            return Container();
          }),
      Expanded(
        child: FutureBuilder(
            future: DatabaseAccess.getInstance()
                .getAllStudentsPartOfTeam(teamNumber),
            builder: (context, teamStudents) {
              if (!teamStudents.hasData) {
                return Container();
              }
              List<Map<String, dynamic>>? students = teamStudents.data;
              FlutterLogs.logInfo("Team list", "students", students.toString());
              return ListView.builder(
                itemCount: students!.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: students[index]['username'] != null
                        ? Text(students[index]['username'])
                        : Text(students[index]['email']),
                    subtitle: students[index]['description'] != null
                        ? Text(students[index]['description'])
                        : students[index]['isAdmin']
                            ? const Text("Mentor")
                            : const Text("Student"),
                    leading: (students[index]['isAdmin'] ||
                            students[index]['isOwner'])
                        ? Image.asset(
                            'assets/images/Mentor2.png',
                            height: 45,
                            width: 65,
                          )
                        : Image.asset(
                            'assets/images/Students2.png',
                            height: 45,
                            width: 65,
                          ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      StudentData.viewingUserEmail = students[index]['email'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetailPage()));
                    },
                  );
                },
              );
            }),
      ),
    ]);
  }
}
