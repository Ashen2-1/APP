import 'package:flutter/material.dart';
import 'package:team_up/constants/colors.dart';

import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

class PageNavigationScreen extends StatefulWidget {
  static Widget? incomingScreen;
  // PageNavigationScreen({super.key});

  static Widget getIncomingScreen() {
    return incomingScreen!;
  }

  static void setIncomingScreen(Widget incomingScreen) {
    PageNavigationScreen.incomingScreen = incomingScreen;
  }

  @override
  State<PageNavigationScreen> createState() => _PageNavigationScreenState();
}

class _PageNavigationScreenState extends State<PageNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(toggleMenuExtend),
      body: ConfigUtils.configForNavMenu(context),
    );
  }

  void toggleMenuExtend() {
    ConfigUtils.goToScreen(PageNavigationScreen.incomingScreen!, context);
  }
}
