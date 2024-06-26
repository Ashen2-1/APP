import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/all_approve_tasks_screen.dart';
import 'package:team_up/screens/all_tasks_view_page.dart';
import 'package:team_up/screens/created_tasks_page.dart';
import 'package:team_up/screens/logs_page.dart';
import 'package:team_up/screens/unassigned_tasks_page.dart';
import 'package:team_up/screens/student_tasks_screen.dart';
import 'package:team_up/services/database_access.dart';

import '../utils/configuration_util.dart';
import '../widgets/nav_bar.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  Future<bool?> isAdmin() async {
    return (await StudentData.isAdmin() ||
        (await DatabaseAccess.getInstance()
            .getField("student tasks", StudentData.studentEmail, "isOwner")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Tasks", textAlign: TextAlign.center),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: buildNavBar(context, 1),
        body: Center(
            child: Container(
          child: Column(children: [
            const SizedBox(height: 20),
            Text(
              "User email: ${StudentData.studentEmail}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                  margin: const EdgeInsets.all(20.0),
                  child: FutureBuilder(
                      future: isAdmin(),
                      builder: (context, isAdmin) {
                        if (!isAdmin.hasData) {
                          return Container();
                        } else {
                          if (isAdmin.data!) {
                            return Column(children: [
                              Row(children: [
                                const SizedBox(width: 40),
                                createClickableIcon(
                                    const Icon(Icons.add_box_outlined,
                                        color: Colors.white, size: 30),
                                    const Color(0xFFFFCF2F), () {
                                  ConfigUtils.goToScreen(
                                      const AddTasksScreen(), context);
                                }, "Add a task!"),
                                const SizedBox(width: 70),
                                createClickableIcon(
                                    const Icon(Icons.check,
                                        color: Colors.white, size: 30),
                                    const Color(0xFF61BDFD), () {
                                  ConfigUtils.goToScreen(
                                      const AllApproveTasksScreen(), context);
                                }, "Approve tasks")
                              ]),
                              const SizedBox(height: 20),
                              Row(children: [
                                const SizedBox(width: 30),
                                createClickableIcon(
                                    const Icon(Icons.assignment_late_outlined),
                                    const Color.fromARGB(255, 245, 80, 39)
                                        .withOpacity(0.3), () {
                                  ConfigUtils.goToScreen(
                                      const UnassignedTasksPage(), context);
                                }, "Unassigned Tasks"),
                                const SizedBox(width: 30),
                                createClickableIcon(
                                    const Icon(Icons.pending_actions_outlined),
                                    Color.fromARGB(255, 39, 221, 245)
                                        .withOpacity(0.3), () {
                                  ConfigUtils.goToScreen(
                                      const CreatedTasksPage(), context);
                                }, "My Pending Tasks")
                              ]),
                              FutureBuilder(
                                  future: DatabaseAccess.getInstance().getField(
                                      "student tasks",
                                      StudentData.studentEmail,
                                      "isOwner"),
                                  builder: (context, isOwner) {
                                    if (!isOwner.hasData || !isOwner.data) {
                                      return Container();
                                    }
                                    //else if (!isOwner.data) {
                                    //   return Container();
                                    // }
                                    return Column(children: [
                                      const SizedBox(height: 20),
                                      Row(children: [
                                        const SizedBox(width: 15),
                                        createClickableIcon(
                                            const Icon(Icons
                                                .admin_panel_settings_outlined),
                                            Color.fromARGB(255, 139, 245, 39)
                                                .withOpacity(0.3), () {
                                          ConfigUtils.goToScreen(
                                              const AllTasksViewPage(),
                                              context);
                                        }, "View All Tasks"),
                                        const SizedBox(width: 70),
                                        createClickableIcon(
                                            const Icon(Icons.list),
                                            Color.fromARGB(255, 139, 245, 39)
                                                .withOpacity(0.3), () {
                                          ConfigUtils.goToScreen(
                                              const LogsPage(), context);
                                        }, "View Logs")
                                      ])
                                    ]);
                                  })
                            ]);
                          } else {
                            return Column(children: [
                              Row(children: [
                                const SizedBox(width: 10),
                                createClickableIcon(
                                    const Icon(Icons.add_box_outlined,
                                        color: Colors.white, size: 30),
                                    const Color(0xFFFFCF2F), () {
                                  ConfigUtils.goToScreen(
                                      const StudentTasksScreen(), context);
                                }, "My Tasks")
                              ])
                            ]);
                          }
                        }
                      }))
            ]),
          ]),
        )));
  }
}
