
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:table_calendar/table_calendar.dart';
void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Calendarpage(),
  ));
}
class Calendarpage extends StatefulWidget {
  const Calendarpage({super.key});

  @override
  State<Calendarpage> createState() => _CalendarpageState();
}

class _CalendarpageState extends State<Calendarpage> {

  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today=day;
    });
  }

  DateTime today = DateTime.now();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      
      body: Container(
        padding: EdgeInsets.only(left:16,top:25,right: 16),
        
        child:Column(
          
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Text("Selected Day: "+today.toString().split(" ")[0]),
            ElevatedButton(
              onPressed:() async{
                
                final DateTime? dateTime = await showDatePicker(
                  
                  context: context,
                  initialDate: today, 
                  firstDate: today, 
                  lastDate: DateTime.utc(9999,08,16)
                );
                if (dateTime != null) {
                  setState(() {
                    today = dateTime; 
                  });
                }
                
              }, 
              child: Text("Select Due Date"),
              ),

          ],
        ),
      ),
    );
  }
}