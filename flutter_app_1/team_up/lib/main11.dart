import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyWidget(),
    );
  }
  //Widget buildButtons(){
    //return ButtonWidget(
      //text: "Start Timer!"
      //onClicked: (){},
    //);
  //}
}





////here is MyWidget just do make a stl and add this to "home:"
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key : key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text("Bottom Sheet"),
        onPressed: () {
          showModalBottomSheet(
            context: context, 
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                
                child: Wrap( //will break to another line on overflow
                  direction: Axis.horizontal, //use vertical to show  on vertical axis
                  children: <Widget>[
                        SizedBox(width: 20,),

                        IconButton(
                          icon: Image.asset('assets/images/Students.png'),
                          iconSize: 160,
                          onPressed: () {},
                        ),
                        SizedBox(width: 5,),

                        IconButton(
                          icon: Image.asset('assets/images/Mentor.png'),
                          iconSize: 160,
                          onPressed: () {},
                        )

                        // Add more buttons here
                ],
            ),
              );

            },
          );
        },
      ),
    );
  }
}