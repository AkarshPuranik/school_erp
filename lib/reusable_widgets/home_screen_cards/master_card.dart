import 'package:flutter/material.dart';

class HomeScreenMasterCard extends StatelessWidget {
  final bool attendance;
  final String tooltext;

  const HomeScreenMasterCard(
      {super.key, required this.attendance, required this.tooltext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
      width: MediaQuery.of(context).size.width / 2.35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color(0xFF345FB4),
        ),
      ),
      child: Tooltip(
        message: tooltext,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              attendance ? "assets/attendance.png" : "assets/fees_due.png",
              height: MediaQuery.of(context).size.width / 6,
            ),
            const SizedBox(height: 24.0),
            Text(
              attendance ? "80%" : "6400",
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              attendance ? "Attendance" : "Fees Due",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF777777),
                fontSize: 16.0,
                height: 1.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
