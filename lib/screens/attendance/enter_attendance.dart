import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_erp/reusable_widgets/loader.dart';

import '../../components/custom_appbar.dart';
import '../../components/star_background.dart';
import '../../constants/colors.dart';
import '../../model/enter_attendance_model.dart';

class EnterAttendance extends StatefulWidget {
  const EnterAttendance({super.key});

  @override
  State<EnterAttendance> createState() => _EnterAttendanceState();
}

class _EnterAttendanceState extends State<EnterAttendance> {
  bool loading = false;
  CollectionReference attendanceCollection = FirebaseFirestore.instance.collection('attendance');

  List<EnterAttendanceModel> attendanceList = [
    EnterAttendanceModel(
      name: "Tanish Pradhan",
      enrollment: "19100BTCSICS05464",
      subject: "BTIT611",
      status: "absent",
      semester: "VI",
    ),
    EnterAttendanceModel(
      name: "Aman Porwal",
      enrollment: "19100BTCSICS05465",
      subject: "BTCS503",
      status: "absent",
      semester: "VI",
    ),
    EnterAttendanceModel(
      name: "Preet Jain",
      enrollment: "19100BTCSICS05466",
      subject: "BTICS502",
      status: "absent",
      semester: "VI",
    ),
  ];

  Future<void> updateAttendance() async {
    showDialog(context: context, builder: (context) => const LoaderDialog());

    for (var element in attendanceList) {
      await attendanceCollection.add({
        "name": element.name,
        "enrollment": element.enrollment,
        "subject": element.subject,
        "status": element.status,
        "semester": element.semester,
      });
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Attendance added successfully",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0)),
        closeIconColor: Colors.white,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2855AE)
            .withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Attendance"),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: attendanceList.length,
                                    itemBuilder: (context, index) {
                                      return MarkAttendanceCard(
                                        studentDetail: attendanceList[index],
                                        onTap: () {
                                          setState(() {
                                            if (attendanceList[index].status == "absent") {
                                              attendanceList[index].status = "present";
                                            } else if (attendanceList[index].status == "present") {
                                              attendanceList[index].status = "absent";
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => updateAttendance(),
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Center(
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MarkAttendanceCard extends StatelessWidget {
  final EnterAttendanceModel studentDetail;
  final VoidCallback onTap;

  const MarkAttendanceCard(
      {super.key, required this.studentDetail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: Colors.black54),
          color: studentDetail.status == "present" ? primaryColor : Colors.white,
        ),
        child: Text(
          studentDetail.name,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
