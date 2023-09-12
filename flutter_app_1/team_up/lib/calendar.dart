import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/main.dart';
import 'package:team_up/services/database_access.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) async {
    getAttendaceStringForDay(day.toString().split(" ")[0]);
    setState(() {
      today = day;
    });
  }

  Future<String> getAttendaceStringForDay(String day) async {
    // List<String> res = await getAttendanceForDay(day.toString().split(" ")[0]);
    // FlutterLogs.logInfo("Attendance", "curent student", res.toString());
    String attendance = "";
    for (String student in await getAttendanceForDay(day)) {
      FlutterLogs.logInfo("Attendance", "curent student", student);
      if (StudentData.viewingOwnAttendance) {
        if (student == StudentData.viewingUserEmail) {
          attendance += "Present on this day";
        }
      } else {
        attendance += "$student \n";
      }
    }
    return attendance;
  }

  Future<List<String>> getAttendanceForDay(String day) async {
    List<String>? res = await DatabaseAccess.getInstance()
        .getDocumentByID("Attendance", day)
        .then((response) => response?.data()?.keys.toList());

    if (res == null) {
      return [];
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: content(),
    );
  }

  Widget content() {
    Future<String> attendanceString =
        getAttendaceStringForDay(today.toString().split(" ")[0]);

    return Container(
        child: FutureBuilder(
            future: attendanceString,
            builder: (context, attendanceString) {
              if (!attendanceString.hasData) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
///////////////////////////////////////////////////////////////////////////////////////////////

                  children: [
                    Text("Selected Day: " + today.toString().split(" ")[0]),
                    Container(
                      child: TableCalendar(
                        locale: "en_US",
                        rowHeight: 43,
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) => isSameDay(day, today),
                        focusedDay: today,
                        firstDay: DateTime.utc(2005, 08, 16),
                        lastDay: DateTime.utc(9999, 08, 16),
                        onDaySelected: _onDaySelected,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Attendance: ", style: TextStyle(fontSize: 21)),
                    const SizedBox(height: 5),
                    Text(attendanceString.data!,
                        style: const TextStyle(fontSize: 16))
                  ],
                ),
              );
            }));
  }
}
