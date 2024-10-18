import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  final String subject;
  final String assignDate;
  final String submissionDate;
  final String chapter;
  final bool submitted;

  const AssignmentCard(
      {super.key,
      required this.subject,
      required this.assignDate,
      required this.submissionDate,
      required this.chapter,
      required this.submitted});

  @override
  Widget build(BuildContext context) {
    double borderRadius = 18.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFE1E3E8),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFF6789CA).withOpacity(0.2),
                  ),
                  child: Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6789CA),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  chapter,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Assign Date",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      assignDate,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Last Submission Date",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      submissionDate,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          submitted
              ? const SizedBox(height: 5.0)
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6789CA),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      "TO BE SUBMITTED",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
