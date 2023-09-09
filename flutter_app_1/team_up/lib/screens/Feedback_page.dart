import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';

import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';

import '../constants/constants.dart';

class Feedback_page extends StatefulWidget {
  @override
  _Feedback_pageState createState() => _Feedback_pageState();
}

class _Feedback_pageState extends State<Feedback_page> {
  // text controller to handle user entered data in textfield
  final TextEditingController _Textcontroller = TextEditingController();

  final List<String> percentageList = [
    '0%',
    '20%',
    '40%',
    '60%',
    '80%',
    "100%"
  ];
  String percentage = "0%";

  String time = "Select a time for task";
  DateTime day = DateTime.now().add(const Duration(minutes: 30));

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: buildNavBar(context, 1),
        appBar: AppBar(title: const Text("Feedback Page")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text("Please Enter Feedback here (At less 50 words)"),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _Textcontroller,
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        hintText: 'Enter A Feedback Here',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("How much has this user completed?"),
                GestureDetector(
                  child: DropdownButton<String>(
                      value: percentage,
                      //hint: const Text("%",
                      //style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                      onChanged: (String? newValue) {
                        setState(() {
                          percentage = newValue!;
                        });
                      },
                      items: percentageList
                          .map<DropdownMenuItem<String>>((String newValue) {
                        return DropdownMenuItem<String>(
                            value: newValue, child: Text(newValue));
                      }).toList()),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("How much more time is needed?"),
                GestureDetector(
                  child: DropdownButton<String>(
                      value: time,
                      //hint: const Text("%",
                      //style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                      onChanged: (String? newValue) {
                        setState(() {
                          time = newValue!;
                        });
                      },
                      items: timeList
                          .map<DropdownMenuItem<String>>((String newValue) {
                        return DropdownMenuItem<String>(
                            value: newValue, child: Text(newValue));
                      }).toList()),
                ),
                const SizedBox(height: 30),
                const Text("What is the new due date?"),
                const SizedBox(height: 10),
                Text("Selected Due Date: ${Util.formatDateTime(day)}"),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () async {
                      DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: day,
                          firstDate: now,
                          lastDate: DateTime.utc(9999, 08, 16));

                      final TimeOfDay? time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (dateTime != null && time != null) {
                        dateTime = dateTime.add(
                            Duration(hours: time.hour, minutes: time.minute));
                      }

                      if (dateTime != null) {
                        setState(() {
                          day = dateTime!;
                        });
                      }
                    },
                    child: const Text("Select a due date")),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> existingTaskData =
                        StudentData.getApprovalTask()!;

                    existingTaskData['feedback'] = _Textcontroller.text;
                    existingTaskData['complete percentage'] = percentage;
                    existingTaskData['completed'] = false;
                    existingTaskData['approved'] = true;
                    existingTaskData['estimated time'] = time;
                    existingTaskData['finish time'] = null;
                    existingTaskData['due date'] = day;

                    List<Map<String, dynamic>> tasks =
                        Util.matchAndCombineExisting(
                            existingTaskData,
                            await DatabaseAccess.getInstance()
                                .getAllSignedUpTasks());
                    DatabaseAccess.getInstance().addToDatabase(
                        "student tasks", "signed up", {"tasks": tasks});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: const Text("Send Message"),
                ),
              ],
            ),
          ),
        ));
  }
}
