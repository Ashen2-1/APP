import 'package:flutter/material.dart';
import 'package:team_up/constants/constants.dart';
import 'package:team_up/screens/tasks_page.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

import '../services/database_access.dart';
import '../widgets/widgets.dart';

class CreatedTasksPage extends StatefulWidget {
  const CreatedTasksPage({Key? key}) : super(key: key);

  @override
  State<CreatedTasksPage> createState() => _CreatedTasksPageState();
}

class _CreatedTasksPageState extends State<CreatedTasksPage> {
  List<Map<String, dynamic>> myCreatedTasks = [];

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
          appBar: AppBar(title: const Text("My Created Tasks - In Progress")),
          bottomNavigationBar: buildNavBar(context, 1),
          body: Column(children: [
            FutureBuilder(
                future:
                    DatabaseAccess.getInstance().getMyCreatedTasksInProgress(),
                builder: (context, createdTasks) {
                  if (!createdTasks.hasData) {
                    return Container();
                  }
                  myCreatedTasks = createdTasks.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: myCreatedTasks.length,
                        itemBuilder: (context, index) {
                          return allViewTaskWidget(myCreatedTasks, index,
                              context, typeOptions[0], "",
                              isForCreated: true);
                        }),
                  );
                }),
            reusableButton("Update my created tasks", context, () async {
              myCreatedTasks = (await DatabaseAccess.getInstance()
                  .getMyCreatedTasksInProgress());
              setState(() {});
            })
          ]),
        ));
  }
}
