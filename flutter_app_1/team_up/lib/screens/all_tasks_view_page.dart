import 'package:flutter/material.dart';
import 'package:team_up/constants/constants.dart';
import 'package:team_up/screens/tasks_page.dart';
import 'package:team_up/widgets/nav_bar.dart';

import '../constants/borders.dart';
import '../services/database_access.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';

class AllTasksViewPage extends StatefulWidget {
  const AllTasksViewPage({Key? key}) : super(key: key);

  @override
  AllTasksViewPageState createState() => AllTasksViewPageState();
}

class AllTasksViewPageState extends State<AllTasksViewPage> {
  List<Map<String, dynamic>> allTasksList = [];

  String type = "Signed up";

  String subteam = "Programming";

  Future<List<Map<String, dynamic>>?> updateAllTasksList(String option,
      {String subteam = ""}) async {
    if (option == typeOptions[0]) {
      return await DatabaseAccess.getInstance().getAllSignedUpTasks();
    } else if (option == typeOptions[1]) {
      return await DatabaseAccess.getInstance().getAvailableTasks("", subteam);
    } else if (option == typeOptions[2]) {
      return await DatabaseAccess.getInstance().getAllUnassignedTasks();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the destination screen and prevent going back to this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TasksPage()),
          );
          return false;
        },
        child: Scaffold(
            appBar: AppBar(title: const Text("All System Tasks")),
            bottomNavigationBar: buildNavBar(context, 1),
            body: Column(children: [
              const SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width - 25,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 199, 196, 196)
                          .withOpacity(0.3),
                      borderRadius: Borders.imageBorderRadius),
                  child: DropdownButton<String>(
                      value: type,
                      // hint: const Text("Select subteam:",
                      //     style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                      onChanged: (String? newValue) async {
                        allTasksList.clear();
                        type = newValue!;
                        setState(() {});
                        //allTasksList = (await updateAllTasksList(newValue!))!;
                        //setState(() {});
                      },
                      items: typeOptions
                          .map<DropdownMenuItem<String>>((String newValue) {
                        return DropdownMenuItem<String>(
                            value: newValue, child: Text(newValue));
                      }).toList())),
              const SizedBox(height: 10),
              if (type == typeOptions[1])
                Column(children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 25,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 196, 196)
                              .withOpacity(0.3),
                          borderRadius: Borders.imageBorderRadius),
                      child: DropdownButton<String>(
                          value: subteam,
                          // hint: const Text("Select subteam:",
                          //     style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                          onChanged: (String? newValue) async {
                            setState(() {
                              allTasksList.clear();
                              subteam = newValue!;
                            });
                            // allTasksList = (await updateAllTasksList(type,
                            //     subteam: newValue!))!;
                            //setState(() {});
                          },
                          items: subteamList
                              .map<DropdownMenuItem<String>>((String newValue) {
                            return DropdownMenuItem<String>(
                                value: newValue, child: Text(newValue));
                          }).toList())),
                  const SizedBox(height: 10),
                ]),
              FutureBuilder(
                  future: updateAllTasksList(type, subteam: subteam),
                  builder: (context, studentTasks) {
                    if (!studentTasks.hasData) {
                      return Container();
                    }
                    allTasksList = studentTasks.data!;
                    return Expanded(
                        child: ListView.builder(
                      itemCount: allTasksList.length,
                      itemBuilder: (context, index) {
                        return allViewTaskWidget(
                            allTasksList, index, context, type, subteam);
                      },
                    ));
                  }),
              reusableButton("Update all tasks", context, () async {
                if (type == typeOptions[1]) {
                  allTasksList =
                      (await updateAllTasksList(type, subteam: subteam))!;
                } else {
                  allTasksList = (await updateAllTasksList(type))!;
                }
                setState(() {});
              }),
            ])));
  }
}
