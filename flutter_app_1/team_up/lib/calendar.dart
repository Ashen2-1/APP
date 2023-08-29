import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team_up/main.dart';


void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today=day;
    });
  }

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Due Date"),),
      body: content(),
    );
  }
  Widget content(){

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        

///////////////////////////////////////////////////////////////////////////////////////////////    
    
      
      
        children: [
          Text("Selected Day: "+today.toString().split(" ")[0]),
          Container(
            child: TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: HeaderStyle(formatButtonVisible: false,titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate:(day) => isSameDay(day,today),
              focusedDay: today, 
              firstDay: DateTime.utc(2005,08,16), 
              lastDay: DateTime.utc(9999,08,16),
              onDaySelected: _onDaySelected,
            ),
          ),
        ],
      ),
    );
  }
}