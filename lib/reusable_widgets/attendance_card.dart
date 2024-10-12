import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendanceCard extends StatelessWidget {
  final String subject;
  final int totalClasses;
  final int present;
  final int absent;
  const AttendanceCard({super.key, required this.subject, required this.totalClasses, required this.present, required this.absent});

  @override
  Widget build(BuildContext context) {
    String attendancePercentage = ((present / totalClasses) * 100).toStringAsFixed(0);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(bottom: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black54)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 7.0,
            animation: true,
            percent: totalClasses == 0 ? 0 : present / totalClasses,
            center: Text(
              "${totalClasses == 0 ? 0 : attendancePercentage}%",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.purple,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  "Total Classes: $totalClasses",
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.chevron_right,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}
