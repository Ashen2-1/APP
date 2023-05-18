import 'package:flutter/material.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  int _time = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("Available time: "),
            ListTile(
              title: const Text('10 mins'),
              leading: Radio<int>(
                value: 10,
                groupValue: _time,
                onChanged: (int? value) {
                  setState(() {
                    _time = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('10 mins'),
              leading: Radio<int>(
                value: 10,
                groupValue: _time,
                onChanged: (int? value) {
                  setState(() {
                    _time = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
