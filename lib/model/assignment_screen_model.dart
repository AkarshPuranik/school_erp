class AssignmentModel {
  final String subject;
  final String topic;
  final String assignDate;
  final String lastDate;
  final bool isSubmitted;

  AssignmentModel(
      {required this.subject,
        required this.topic,
        required this.assignDate,
        required this.lastDate,
        required this.isSubmitted,
      });
}