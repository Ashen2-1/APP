import 'package:firebase_core/firebase_core.dart';
import 'package:team_up/services/firebase_access.dart';

import '../services/database_access.dart';

class StudentData {
  static String studentEmail = FirebaseAccess.getInstance().getUserEmail();
  static String default_subteam = "Programming";
  static String querying_subteam = default_subteam;
  static String signingUpTeamNumber = "";
  static String studentTeamNumber = "None";

  static Map<String, dynamic>? currentTask;

  static Map<String, dynamic>? approvalTask;

  static Map<String, dynamic>? getApprovalTask() {
    return approvalTask;
  }

  static Future<bool> isAdmin() async {
    return await DatabaseAccess.getInstance()
        .getField("student tasks", studentEmail, "isAdmin");
  }

  //////////////////////////////new
  static List<Map<String, dynamic>>? allViewingTask;
  /////////////////////////// Descrption
  static String? descriptionIncomingPage;
  static int? viewingIndex;

  static Future<String> getStudentTeamNumber() async {
    Map<String, dynamic>? studentStats =
        await DatabaseAccess.getInstance().getStudentStats();
    return (studentStats == null || studentStats['team number'] == null
        ? "None"
        : studentStats['team number']);
  }

  static setDescriptionIncomingPage(String incomingPage) {
    descriptionIncomingPage = incomingPage;
  }

  static void setCurrentTask(Map<String, dynamic> newTask) {
    currentTask = newTask;
  }

  static void setViewingTask(List<Map<String, dynamic>> newViewingTask) {
    allViewingTask = newViewingTask;
  }

  static void setQuerySubTeam(String newSubTeam) {
    querying_subteam = newSubTeam;
  }

  static String getQuerySubTeam() {
    return querying_subteam;
  }
}
