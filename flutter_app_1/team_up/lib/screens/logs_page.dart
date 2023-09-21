import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/widgets/nav_bar.dart';

import '../services/database_access.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  State<LogsPage> createState() => LogsPageState();
}

class LogsPageState extends State<LogsPage> {
  Future<List<String>> getAllLogs() async {
    String teamNumber = await DatabaseAccess.getInstance()
        .getField("student tasks", StudentData.studentEmail, "team number");
    dynamic res =
        await DatabaseAccess.getInstance().getField("logs", teamNumber, "logs");
    return res.cast<String>();
  }

  List<String> allLogsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Logs")),
        bottomNavigationBar: buildNavBar(context, 1),
        body: Column(children: [
          FutureBuilder(
              future: getAllLogs(),
              builder: (context, logs) {
                if (!logs.hasData) {
                  return Container();
                }
                allLogsList = logs.data!;
                return Expanded(
                    child: ListView.builder(
                  itemCount: allLogsList.length,
                  itemBuilder: (context, index) {
                    return logWidget(logs.data![index], context);
                  },
                ));
              }),
          reusableButton("Update logs", context, () async {
            allLogsList = (await getAllLogs());
            setState(() {});
          }),
        ]));
  }
}
