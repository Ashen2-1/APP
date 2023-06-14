import '../services/database_access.dart';

class StudentData {
  static const String studentName = "Eric";
  static String current_subteam = "Programming";
  static String? querying_subteam;

  static void setQuerySubTeam(String newSubTeam) {
    querying_subteam = newSubTeam;
  }

  static String getQuerySubTeam() {
    return querying_subteam!;
  }
}
