import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_tasks_screen.dart';
import 'package:team_up/screens/web_view_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/fonts.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:team_up/screens/home_screen.dart';
import '../services/file_uploader.dart';
import '../services/internet_connection.dart';
import '../widgets/round-button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';
import '../widgets/widgets.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class AppLifecycleObserver extends WidgetsBindingObserver {}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  final TextEditingController _Textcontroller = TextEditingController();

  bool image = false;

  bool isPlaying = true;
  File? file;

  String fileURL = "None";
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  Future<void> submit(String fileURL) async {
    if (!(await connectedToInternet())) {
      await displayError(
          "You are not connected to the Internet, connect and press ok to try again",
          context);
      submit(fileURL);
    } else {
      Map<String, dynamic> taskToAdd = StudentData.currentTask!;
      taskToAdd['completed'] = true;
      taskToAdd['submit file url'] = fileURL;
      taskToAdd['approved'] = false;
      taskToAdd['submit comments'] = _Textcontroller.text;
      taskToAdd['submit time'] = Timestamp.now();

      List<Map<String, dynamic>> curPendingTasks = Util.matchAndCombineExisting(
          taskToAdd, await DatabaseAccess.getInstance().getAllSignedUpTasks());

      DatabaseAccess.getInstance().addToDatabase(
          "student tasks", 'signed up', {'tasks': curPendingTasks});

      if (taskToAdd['machine needed'] != null) {
        DatabaseAccess.getInstance().updateField(
            "Machines", "Occupied", {taskToAdd['machine needed']: ""});
      }

      FlutterLogs.logInfo(
          "Student task", "Submission", "Successfully submitted");

      image = false;
      _Textcontroller.text = "";

      ConfigUtils.goToScreen(HomeScreen(), context);
    }
  }

  void notify() async {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.stop();
      submit(fileURL);
    }
    if (countText == "0:01:00") {
      FlutterRingtonePlayer.playNotification();
      FlutterRingtonePlayer.playAlarm(looping: false, asAlarm: false);
      // await displayAlert(
      //     "1 minute left! Will auto submit at time 0 sec", context);
    } else if (countText == '0:05:00') {
      FlutterRingtonePlayer.playNotification();
      // await displayAlert(
      //     "5 minutes left! Will auto submit at time 0 sec", context);
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterLogs.logInfo("Count Down", "Finish time",
        "${StudentData.currentTask!['finish time']}");
    DateTime finishTime = StudentData.currentTask!['finish time'].toDate();
    Duration time = finishTime.difference(DateTime.now());
    FlutterLogs.logInfo("Count Down", "Time stamp",
        "Current time: ${StudentData.currentTask!['finish time']}");

    // Duration time =
    //     StudentData.currentTask!['finish time'].difference(DateTime.now());
    controller = AnimationController(vsync: this, duration: time

        /// change time here
        );

    controller.addListener(() {
      notify();
    });
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(const CountdownPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to the destination screen and prevent going back to this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentTasksScreen()),
          );
          return false;
        },
        child: Scaffold(
            //appBar: buildAppBar(menuToggleExpansion),
            appBar: AppBar(title: const Text("Work Countdown")),
            bottomNavigationBar: buildNavBar(context, 1),
            backgroundColor: Color(0xfff5fbff),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Current Task: ${StudentData.currentTask!['task']}",
                    style: TextStyle(fontSize: 25, decorationThickness: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text("Will auto submit at time 0:00:00!!"),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey.shade300,
                            value: progress,
                            strokeWidth: 6,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.isDismissed) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  height: 300,
                                  child: CupertinoTimerPicker(
                                    initialTimerDuration: controller.duration!,
                                    onTimerDurationChanged: (time) {
                                      setState(() {
                                        controller.duration = time;
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) => Text(
                              countText,
                              style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  reusableButton("Upload a file related to task", context,
                      () async {
                    File result = (await FileUploader.pickFile())!;
                    setState(() {
                      file = result;
                      isPlaying = true;
                    });
                    if (file != null) {
                      List<String> fileInfo = file!.path.split(".");
                      String fileType = fileInfo.last.toLowerCase();
                      List<String> fileParts =
                          file!.path.split('/').last.split('.');

                      String fileName =
                          fileParts.sublist(0, fileParts.length - 1).join(".");

                      FlutterLogs.logInfo("FileNAMe", "Display", fileName);
                      if (fileName.contains(".jpg") ||
                          fileName.contains(".png") ||
                          fileName.contains(".jpeg")) {
                        fileURL = "";
                        image = false;
                        displayError(
                            "Please do not submit a file with a name containing '.jpg', '.png', or '.jpeg' consecutive letters",
                            context);
                      } else {
                        TaskSnapshot imageSnapshot =
                            await FileUploader.getInstance()
                                .addFileToFirebaseStorage(file!);
                        fileURL = await imageSnapshot.ref.getDownloadURL();
                        if (fileType == "png" ||
                            fileType == 'jpg' ||
                            fileType == 'jpeg') {
                          image = true;
                        } else {
                          image = false;
                        }
                      }
                    }
                    setState(() {});
                  }),
                  // if (fileURL != "None") WebView(initialUrl: fileURL),
                  const Text("View uploaded file", style: defaultFont),
                  image
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(fileURL))
                      : SelectableText(fileURL,
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                  // onDoubleTap: () async {
                  //   //WebViewPage.setURL(fileURL);
                  //   //ConfigUtils.goToScreen(WebViewPage(), context);
                  //   ConfigUtils.goToScreen(OpenUrlInWebView(url: fileURL), context);
                  // }
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: _Textcontroller,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: 'Enter Your Submission Comments',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 104, 102, 102)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                  ),

                  reusableButton("Submit for approval", context, () async {
                    await submit(fileURL);
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(height: 10,),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
