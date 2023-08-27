import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/Jointeam_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';

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
            return Jointeam_page();
          } else {
            return buildTeamList(context, studentTeamNumber.data);
          }
        });
  }

  Scaffold buildTeamList(context, String teamNumber) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My team"),
        ),
        bottomNavigationBar: buildNavBar(context, 2),
        body: _buildListView(context, teamNumber));
  }

  ListView _buildListView(BuildContext context, String teamNumber) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text("The menber #$index $teamNumber"),
          subtitle: Text("The subtitle"),
          leading: Image.asset(
            'assets/images/Students2.png',
            height: 45,
            width: 65,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailPage(index)));
          },
        );
      },
    );
  }
}
