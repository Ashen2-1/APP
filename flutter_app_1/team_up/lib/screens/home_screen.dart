import 'package:flutter/material.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return Column();
  }
}
