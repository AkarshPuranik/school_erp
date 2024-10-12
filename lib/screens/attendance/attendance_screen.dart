import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/model/attendance_model.dart';
import 'package:school_erp/reusable_widgets/attendance_card.dart';

import '../../constants/colors.dart';
import '../../model/user_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  Box<UserModel> userBox = Hive.box<UserModel>('users');

  CollectionReference syllabusCollection =
      FirebaseFirestore.instance.collection('syllabus');

  CollectionReference subjectsCollection =
  FirebaseFirestore.instance.collection('subjects');

  CollectionReference attendanceCollection =
      FirebaseFirestore.instance.collection('attendance');
  List<String> attendanceList = [];

  List<AttendanceModel> attendance = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await syllabusCollection
        .where("semester", isEqualTo: userBox.get("user")?.semester)
        .where("branch", isEqualTo: userBox.get("user")?.branch)
        .get().then((value) => value.docs.forEach((element) {
          setState(() {
            attendanceList = List.from(element["subjects"]);
            debugPrint("Subject: ${attendanceList[0]}");
          });
          debugPrint("EventList: ${attendanceList.toString()}");
        }));

    getAttendance();
  }

  Future<void> getAttendance() async {
    for (var element in attendanceList) {
      int total = 0;
      int attended = 0;
      int unattended = 0; 
      String subject = "";
      
      await subjectsCollection.where("subject_code", isEqualTo: element).get().then((value) => {
        setState(() {
          subject = value.docs[0]['subject_name'];
        }),
      });
      
      await attendanceCollection
          .where("subject", isEqualTo: element)
          .where("enrollment",
              isEqualTo: userBox.get("user")?.enrollmentNumber ?? "")
          .where("semester", isEqualTo: userBox.get("user")?.semester ?? "")
          .get()
          .then((value) => {
            setState(() {
              total = value.size;
            }),
            debugPrint("Size: ${value.size}"),
      });

      await attendanceCollection
          .where("subject", isEqualTo: element)
          .where("enrollment",
          isEqualTo: userBox.get("user")?.enrollmentNumber ?? "")
          .where("semester", isEqualTo: userBox.get("user")?.semester ?? "")
          .where("status", isEqualTo: "absent")
          .get()
          .then((value) => {
        setState(() {
          unattended = value.size;
        }),
        debugPrint("unattended: ${value.size}"),
      });

      await attendanceCollection
          .where("subject", isEqualTo: element)
          .where("enrollment",
          isEqualTo: userBox.get("user")?.enrollmentNumber ?? "")
          .where("semester", isEqualTo: userBox.get("user")?.semester ?? "")
          .where("status", isEqualTo: "present")
          .get()
          .then((value) => {
        setState(() {
          attended = value.size;
        }),
        debugPrint("unattended: ${value.size}"),
      });

      setState(() {
        attendance.add(AttendanceModel(subject: subject, totalClasses: total, attendedClasses: attended, unAttendedClasses: unattended));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              "assets/Star_Background.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                const CustomAppBar(title: "Attendance"),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: attendance.isEmpty ? 0.0 : 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                      child: attendance.isEmpty
                          ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: primaryColor,
                              ),
                              SizedBox(height: 14.0),
                              Text(
                                "Loading data...",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                          : SingleChildScrollView(
                            child: Column(
                                children: [
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: attendance.length,
                                    itemBuilder: (context, index) {
                                      return AttendanceCard(
                                        subject: attendance[index].subject,
                                        totalClasses: attendance[index].totalClasses,
                                        present: attendance[index].attendedClasses,
                                        absent: attendance[index].unAttendedClasses,
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
