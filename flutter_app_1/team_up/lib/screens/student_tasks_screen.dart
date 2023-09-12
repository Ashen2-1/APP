import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../utils/util.dart';
import 'TaskDescription_page.dart';
import 'countdown-page.dart';

class StudentTasksScreen extends StatefulWidget {
  const StudentTasksScreen({Key? key}) : super(key: key);

  @override
  State<StudentTasksScreen> createState() => _StudentTasksScreenState();
}

class _StudentTasksScreenState extends State<StudentTasksScreen> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap = [];
  //List<String> task = [];

  Future<void> configure() async {
    //studentTasksMap
    studentTasksMap = await DatabaseAccess.getInstance().getStudentTasks();
    FlutterLogs.logInfo(
        "My Tasks", "Add to ListView", "studentTasksMap: ${studentTasksMap}");
    // for (String imageUrl in imageUrlList) {
    //   resizedImageList.add(await Util.resizeImage(imageUrl, 1 / 8));
    // }
    setState(() {});
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
      appBar: AppBar(title: const Text("My Tasks")),
      bottomNavigationBar: buildNavBar(context, 1),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return Column(
      children: [
        FutureBuilder(
            future: DatabaseAccess.getInstance().getStudentTasks(),
            builder: (context, studentTasks) {
              if (!studentTasks.hasData) {
                return Container();
              }
              studentTasksMap = studentTasks.data;
              return Expanded(
                  child: ListView.builder(
                itemCount: studentTasksMap!.length,
                itemBuilder: (context, index) {
                  return studentTaskInfoWidget(
                      studentTasksMap!, index, context);
                },
              ));
            }),
        reusableButton("Update my tasks", context, () async {
          configure();
        }),
      ],
    );
  }
}
