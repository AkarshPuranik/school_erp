class AttendanceModel {
  final String subject;
  final int totalClasses;
  final int attendedClasses;
  final int unAttendedClasses;

  AttendanceModel(
      {required this.subject,
        required this.totalClasses,
        required this.attendedClasses,
        required this.unAttendedClasses}
      );
}