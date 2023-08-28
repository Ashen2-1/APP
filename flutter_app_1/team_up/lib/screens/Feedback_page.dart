import 'package:flutter/material.dart';
import 'package:team_up/constants/student_data.dart';

import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/util.dart';
import 'package:team_up/widgets/nav_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildNavBar(context, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please Enter Feedback here (At less 50 words)"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _Textcontroller,
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Enter A Feedback Here',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("How much has this user completed?"),
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
            SizedBox(
              height: 50,
            ),
            Text("How much more time is needed?"),
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
            SizedBox(
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

                List<Map<String, dynamic>> tasks = Util.matchAndCombineExisting(
                    existingTaskData,
                    await DatabaseAccess.getInstance().getAllSignedUpTasks());
                DatabaseAccess.getInstance().addToDatabase(
                    "student tasks", "signed up", {"tasks": tasks});
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text("Send Message"),
            ),
          ],
        ),
      ),
    );
  }
}
