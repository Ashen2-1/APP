import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../utils/util.dart';

class AllApproveTasksScreen extends StatefulWidget {
  const AllApproveTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllApproveTasksScreen> createState() => _AllApproveTasksScreenState();
}

class _AllApproveTasksScreenState extends State<AllApproveTasksScreen> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap;
  //List<String> task = [];

  List<String> studentTasks = [];
  List<String> dueDates = [];
  List<String> skillsNeeded = [];
  List<String> imageUrlList = [];

  Future<void> configure() async {
    //studentTasksMap
    studentTasksMap =
        await DatabaseAccess.getInstance().getStudentSubmissions();
    FlutterLogs.logInfo(
        "My Tasks", "Add to ListView", "studentTasksMap: ${studentTasksMap}");
    for (Map<String, dynamic> taskMap in studentTasksMap!) {
      if (!Util.contains(taskMap['task'], studentTasks)) {
        studentTasks.add(taskMap['task']);
        FlutterLogs.logInfo("My Tasks", "Add to ListView",
            "Displaying task: ${taskMap['task']}");
        dueDates.add(taskMap['due date']);
        skillsNeeded.add(taskMap['skills needed']);
        imageUrlList.add(taskMap['image url']);
      }
    }
    // for (String imageUrl in imageUrlList) {
    //   resizedImageList.add(await Util.resizeImage(imageUrl, 1 / 8));
    // }
    setState(() {});
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(AllApproveTasksScreen());
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
        regularText("Approving Tasks", context, true),
        Expanded(
          child: ListView.builder(
            itemCount: studentTasks.length,
            itemBuilder: (context, index) {
              return textFieldTaskInfo(
                  studentTasks[index],
                  dueDates[index],
                  skillsNeeded[index],
                  imageUrlList[index],
                  false,
                  false,
                  true,
                  context);
            },
          ),
        ),
        reusableButton("Update tasks to approve", context, () async {
          configure();
        }),
      ],
    );
  }
}
