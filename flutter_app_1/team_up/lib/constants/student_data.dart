import 'package:firebase_core/firebase_core.dart';
import 'package:team_up/services/firebase_access.dart';

import '../services/database_access.dart';

class StudentData {
  static String studentEmail = FirebaseAccess.getInstance().getUserEmail();
  static String default_subteam = "Programming";
  static String querying_subteam = default_subteam;
  static String? studentTeamNumber;

  static String? currentTask;

  static Map<String, dynamic>? approvalTask;

  static Map<String, dynamic>? getApprovalTask() {
    return approvalTask;
  }

  static bool isAdmin = true;

  //////////////////////////////new
  static String? currentDescrption;
  /////////////////////////// Descrption

  static Future<String> getStudentTeamNumber() async {
    return (await DatabaseAccess.getInstance()
        .getStudentStats())!['team number'];
  }

  static void setCurrentTask(String newTask) {
    currentTask = newTask;
  }

  static void setCurrentDescrption(String newDescription) {
    currentDescrption = newDescription;
  }

  static void setQuerySubTeam(String newSubTeam) {
    querying_subteam = newSubTeam;
  }

  static String getQuerySubTeam() {
    return querying_subteam;
  }
}
