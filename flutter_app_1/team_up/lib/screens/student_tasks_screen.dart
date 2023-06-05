import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';

class StudentTasksScreen extends StatefulWidget {
  const StudentTasksScreen({Key? key}) : super(key: key);

  @override
  State<StudentTasksScreen> createState() => _StudentTasksScreenState();
}

class _StudentTasksScreenState extends State<StudentTasksScreen> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap;
  //List<String> task = [];

  List<String> studentTasks = [];
  List<String> dueDates = [];
  List<String> skillsNeeded = [];

  Future<void> configure() async {
    //studentTasksMap
    studentTasksMap = await DatabaseAccess.getInstance().getStudentTasks();

    setState(() {
      FlutterLogs.logInfo(
          "My Tasks", "Add to ListView", "studentTasksMap: ${studentTasksMap}");
      for (Map<String, dynamic> taskMap in studentTasksMap!) {
        studentTasks.add(taskMap['task']);
        FlutterLogs.logInfo("My Tasks", "Add to ListView",
            "Displaying task: ${taskMap['task']}");
        dueDates.add(taskMap['due date']);
        skillsNeeded.add(taskMap['skills needed']);
      }
    });
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(StudentTasksScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return Column(
      children: [
        regularText("My Tasks", context, true),
        Expanded(
          child: ListView.builder(
            itemCount: studentTasks.length,
            itemBuilder: (context, index) {
              return textFieldTaskInfo(studentTasks[index], dueDates[index],
                  skillsNeeded[index], false, context);
            },
          ),
        ),
        reusableButton("Update my tasks", context, () async {
          configure();
        }),
      ],
    );
  }
}
