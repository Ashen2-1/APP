import 'package:flutter/material.dart';
import 'package:team_up/widgets/nav_bar.dart';

import 'member_details_page.dart';

class MyTeamPage extends StatelessWidget {
  const MyTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Team members list"),
      ),
      bottomNavigationBar: buildNavBar(context, 2),
      body: _buildListView(context),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text("The menber #$index"),
          subtitle: Text("The subtitle"),
          leading: Image.asset(
            'assets/images/Students2.png',
            height: 45,
            width: 65,
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailPage(index)));
          },
        );
      },
    );
  }
}
