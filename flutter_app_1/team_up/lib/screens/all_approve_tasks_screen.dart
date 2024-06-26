import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/tasks_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../constants/student_data.dart';
import '../utils/util.dart';
import 'Approve_page.dart';

class AllApproveTasksScreen extends StatefulWidget {
  const AllApproveTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllApproveTasksScreen> createState() => _AllApproveTasksScreenState();
}

class _AllApproveTasksScreenState extends State<AllApproveTasksScreen> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap = [];
  //List<String> task = [];

  List<String> studentTasks = [];
  List<String> imageURL = [];

  Future<void> configure() async {
    studentTasksMap =
        await DatabaseAccess.getInstance().getMyAssignedStudentSubmissions();
    ;
    FlutterLogs.logInfo(
        "My Tasks", "Add to ListView", "studentTasksMap: ${studentTasksMap}");
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
      appBar: AppBar(title: const Text("Approve tasks")),
      //appBar: buildAppBar(menuToggleExpansion),
      bottomNavigationBar: buildNavBar(context, 1),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the destination screen and prevent going back to this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TasksPage()),
          );
          return false;
        },
        child: Column(children: [
          FutureBuilder(
              future: DatabaseAccess.getInstance()
                  .getMyAssignedStudentSubmissions(),
              builder: (context, submissions) {
                if (!submissions.hasData) {
                  return Container();
                }
                studentTasksMap = submissions.data;
                return Expanded(
                  child: ListView.builder(
                      itemCount: studentTasksMap!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 177, 167, 167)
                                    .withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Row(children: [
                              Column(children: [
                                regularText(studentTasksMap![index]['task'],
                                    context, true),
                                regularText(
                                    "Submission time:\n${Util.formatDateTime((studentTasksMap![index]['submit time'] ?? studentTasksMap![index]['due date']).toDate())}",
                                    context,
                                    false),
                                const SizedBox(height: 10),
                                reusableSignUpTaskButton(
                                    "APPROVE this task", context, () {
                                  StudentData.approvalTask =
                                      studentTasksMap![index];
                                  ConfigUtils.goToScreen(
                                      const Approve_page(), context);
                                })
                              ]),
                              // if (imageURL[index] != "None")
                              //   Expanded(child: Image.network(imageURL[index]))
                            ]));
                      }),
                );
              }),
          reusableButton("Update tasks to approve", context, () async {
            configure();
          })
        ]));
  }
}
