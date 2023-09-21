import 'package:flutter/material.dart';
import 'package:team_up/widgets/nav_bar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("All System Tasks")),
        bottomNavigationBar: buildNavBar(context, 1),
        body: Column(children: [
          FutureBuilder(
              future: DatabaseAccess.getInstance().getAllSignedUpTasks(),
              builder: (context, studentTasks) {
                if (!studentTasks.hasData) {
                  return Container();
                }
                allTasksList = studentTasks.data!;
                return Expanded(
                    child: ListView.builder(
                  itemCount: allTasksList.length,
                  itemBuilder: (context, index) {
                    return allViewTaskWidget(allTasksList, index, context);
                  },
                ));
              }),
          reusableButton("Update all tasks", context, () async {
            allTasksList =
                (await DatabaseAccess.getInstance().getAllSignedUpTasks())!;
          }),
        ]));
  }
}
