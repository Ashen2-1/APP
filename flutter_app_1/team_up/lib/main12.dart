import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/main12details.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ListView",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
  //Widget buildButtons(){
    //return ButtonWidget(
      //text: "Start Timer!"
      //onClicked: (){},
    //);
  //}
}

class MyHomePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Team menbers list"
        ),
      ),
      body: _buildListView(context),
    );
  }
  
  ListView _buildListView(BuildContext context) {
    return ListView.builder(
      
      itemCount: 100,
      
      itemBuilder: (_,index) {
        

        return ListTile(
          
          title: Text("The menber #$index"),
          subtitle: Text("The subtitle"),
          leading: Image.asset('assets/images/Students2.png',height: 45,width: 65,),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
               MaterialPageRoute(builder: (context) => DetailPage(index)));
            
          } ,
          
        );
        
      },
    
    );
  }
}