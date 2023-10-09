import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/Enterteampasscode_page.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../utils/util.dart';

class Jointeam_page extends StatefulWidget {
  const Jointeam_page({Key? key}) : super(key: key);

  @override
  State<Jointeam_page> createState() => _Jointeam_pageState();
}

class _Jointeam_pageState extends State<Jointeam_page> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap;
  //List<String> task = [];
  Map<String, dynamic>? team;

  TextEditingController _teamnumberTextController = TextEditingController();

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(Jointeam_page());
    });
  }

  void searchTeams(String team_number) async {
    //FlutterLogs.logInfo(
    // "Join team", "searching team", "Searching for $team_number");
    try {
      team = await DatabaseAccess.getInstance().getPotentialTeam(team_number);
    } catch (e) {
      displayError("Please enter a team", context);
    }
    if (team == null) displayAlert("$team_number does not exist", context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(
        () => mainLayout(context), context);
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
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
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        const Text(
          "Available Teams: ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),

        reusableTextFieldRegular(
            "Enter Specific Team Number", _teamnumberTextController, false),

        // to search their team by team number!

        //ListTile(
        //title: const Text('Team number:'),

        //),
        if (team != null)
          SizedBox(
              height: 180.0,
              width: MediaQuery.of(context).size.width - 10,
              child: Container(
                height: 180.0,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                //width: 200.0, //MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 6, 227, 201).withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        regularText("Team Number: ${team!['team number']}",
                            context, true),
                        regularText(
                            "Team Name: ${team!['team name']}", context, false),
                        reusableSignUpTaskButton(
                            "Sign up for this team", context, () {
                          StudentData.signingUpTeamNumber =
                              team!['team number'];
                          ConfigUtils.goToScreen(
                              const Enterteampasscode_page(), context);
                        }),
                      ]),
                  if (team!['team logo url'] != "None")
                    Expanded(child: Image.network(team!['team logo url'])),
                ]),
              )),
        // SizedBox(
        //   height: 300,
        // ),

        reusableButton("Search For Team", context, () async {
          searchTeams(_teamnumberTextController.text);
        }),
      ],
    );
  }
}
