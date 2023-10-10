import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:team_up/constants/student_data.dart';

import 'package:team_up/screens/Feedback_page.dart';
import 'package:team_up/screens/all_approve_tasks_screen.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/web_view_page.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/colors.dart';
import '../services/database_access.dart';
import '../services/internet_connection.dart';
import '../utils/configuration_util.dart';
import '../utils/fonts.dart';
import '../utils/util.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

class Approve_page extends StatefulWidget {
  const Approve_page({Key? key}) : super(key: key);

  @override
  _Approve_pageState createState() => _Approve_pageState();
}

class _Approve_pageState extends State<Approve_page> {
  bool isPlaying = false;

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const Approve_page());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(() {
      return mainLayout(context);
    }, context);
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(title: const Text("Approving task")),
      //appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(context),
      bottomNavigationBar: buildNavBar(context, 1),
    );
  }

  @override
  Widget buildMainContent(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the destination screen and prevent going back to this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AllApproveTasksScreen()),
          );
          return false;
        },
        child: Scaffold(
            backgroundColor: const Color(0xfff5fbff),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text("Approving task:\n${StudentData.approvalTask!['task']}",
                      style: defaultFont, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: const [
                        Text("Submitted file:", style: defaultFont),
                        Text("If link, click to view")
                      ])),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: StudentData.approvalTask!['submit file url']
                            .cast<String>()
                            .map((file) => Util.checkValidImage(file)
                                ? Image.network(file)
                                : (file != "None")
                                    ? InkWell(
                                        onTap: () async {
                                          await launchUrlString(file,
                                              webOnlyWindowName: "_blank");
                                        },
                                        child: Text(file.toString(),
                                            style: const TextStyle(
                                                color: Colors.blue)))
                                    : const Text("None", style: defaultFont))
                            .toList()
                            .cast<Widget>(),
                      )),
                  // ElevatedButton(
                  //     child: Text("Download and open file", style: defaultFont),
                  // Text("${StudentData.approvalTask!['submit file url']}",
                  //     style:
                  //         StudentData.approvalTask!['submit file url'] != "None"
                  //             ? const TextStyle(
                  //                 fontSize: 13,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.blue,
                  //                 decoration: TextDecoration.underline)
                  //             : defaultFont),
                  // onPressed: () async {
                  //   String fileURL =
                  //       StudentData.approvalTask!['submit file url'];
                  //   //if (fileURL != "None") {
                  //   //FlutterLogs.logInfo(
                  //       "open file method", "open", "In open file method");
                  //   await openFile(
                  //       "https://cdn.discordapp.com/attachments/1102762971949695048/1120172904580124692/Advice.pdf",
                  //       //"https://firebasestorage.googleapis.com/v0/b/team-up1-a6ad3.appspot.com/o/student_files%2F1360%20Programming%20Attendance%20October-12-2022.pdf?alt=media&token=561b9da9-c5b4-4a47-9090-8b6424c821f7",
                  //       "Advice.pdf");
                  //   //}
                  // ConfigUtils.goToScreen(
                  //     OpenUrlInWebView(
                  //         url: StudentData.approvalTask!['submit file url']),
                  //     context);
                  // }),
                  const SizedBox(
                    height: 0,
                    width: 20,
                  ),
                  const Text("Submitter's comments: ", style: defaultFont),
                  const SizedBox(height: 10),
                  Text(StudentData.approvalTask!['submit comments'] ?? "None",
                      style: const TextStyle(fontSize: 15)),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Feedback_page()));
                          },
                          child: const RoundButton(
                            icon: Icons.close,
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            if (!(await connectedToInternet())) {
                              displayError(
                                  "You are not connected to the Internet",
                                  context);
                            } else {
                              Map<String, dynamic> existingTaskData =
                                  StudentData.getApprovalTask()!;

                              existingTaskData['complete percentage'] = "100%";
                              existingTaskData['feedback'] = "None";
                              existingTaskData['approved'] = true;

                              List<Map<String, dynamic>> tasks =
                                  Util.matchAndCombineExisting(
                                      existingTaskData,
                                      await DatabaseAccess.getInstance()
                                          .getAllSignedUpTasks());
                              DatabaseAccess.getInstance().addToDatabase(
                                  "student tasks",
                                  'signed up',
                                  {"tasks": tasks});

                              await Util.addToLog(
                                  "${StudentData.studentEmail} approved ${existingTaskData['task']}");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AllApproveTasksScreen()));
                            }
                          },
                          child: const RoundButton(
                            icon: Icons.check,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  // Future<void> openFile(String url, String name) async {
  //   File? file = await downloadFile(url, name);
  //   if (file != null) {
  //     //FlutterLogs.logInfo("Open file", "file download path", "${file.path}");
  //     OpenFile.open("1360 Programming Attendance October-12-2022.pdf");
  //   }
  // }

  // Future<File?> downloadFile(String fileURL, String s) async {
  //   //final appStorage = await getApplicationDocumentsDirectory();

  //   final file = File('Download/$s');

  //   final response = await Dio().get(fileURL,
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           receiveTimeout: 0));

  //   final fileWriter = file.openSync(mode: FileMode.write);
  //   fileWriter.writeFromSync(response.data);
  //   await fileWriter.close();

  //   return file;
  // }
}
