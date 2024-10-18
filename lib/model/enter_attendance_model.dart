import 'package:flutter/material.dart';

class EnterAttendanceModel {
  final String name;
  final String enrollment;
  final String semester;
  String status;
  final String subject;

  EnterAttendanceModel({
    required this.name,
    required this.enrollment,
    required this.semester,
    required this.status,
    required this.subject,
  });
}