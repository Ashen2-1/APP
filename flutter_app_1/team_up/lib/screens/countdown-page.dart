import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/web_view_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/file_uploader.dart';
import '../widgets/round-button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';
import '../widgets/widgets.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;
  File? file;

  String fileURL = "None";
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 60),

      /// change time here
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: buildAppBar(),
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          SizedBox(height: 80.0),
          Text("Current Task: ${StudentData.currentTask!}",
              style: TextStyle(fontSize: 25, decorationThickness: 1.5)),
          Expanded(
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
          reusableButton("Upload a file related to task", context, () async {
            File result = (await FileUploader.pickFile())!;
            setState(() {
              file = result;
              isPlaying = true;
            });
            TaskSnapshot imageSnapshot = await FileUploader.getInstance()
                .addFileToFirebaseStorage(file!);
            fileURL = await imageSnapshot.ref.getDownloadURL();
            setState(() {});
          }),
          // if (fileURL != "None") WebView(initialUrl: fileURL),
          GestureDetector(
              child: Text("View the file:\n$fileURL",
                  style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
              onDoubleTap: () async {
                //WebViewPage.setURL(fileURL);
                //ConfigUtils.goToScreen(WebViewPage(), context);
                ConfigUtils.goToScreen(OpenUrlInWebView(url: fileURL), context);
              }),
          reusableButton("Submit for approval", context, () async {
            if (file != null) {
              Map<String, dynamic> taskToAdd = {
                'task completed': StudentData.currentTask,
                'file url': fileURL
              };

              List<Map<String, dynamic>> curPendingTasks =
                  await Util.combineTaskIntoExisting(
                      taskToAdd,
                      await DatabaseAccess.getInstance()
                          .getStudentSubmissions());

              DatabaseAccess.getInstance().addToDatabase("submissions",
                  StudentData.studentEmail, {'submission': curPendingTasks});

              FlutterLogs.logInfo(
                  "Student task", "Submission", "Successfully submitted");
            }
          }),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                //SizedBox(height: 10,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
