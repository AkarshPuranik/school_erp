import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/components/star_background.dart';
import 'package:school_erp/constants/colors.dart';
import 'package:school_erp/model/assignment_screen_model.dart';

import '../reusable_widgets/assignment_card.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool loading = true;

  CollectionReference firestore =
      FirebaseFirestore.instance.collection('assignment');
  List<AssignmentModel> assignmentList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    await firestore.get().then((value) => value.docs.forEach((element) {
          setState(() {
            assignmentList.add(
              AssignmentModel(
                subject: element['subject'],
                topic: element['topic'],
                assignDate: element['assign_date'],
                lastDate: element['last_date'],
                isSubmitted: element['submitted'],
              ),
            );
          });
          debugPrint("EventList: ${assignmentList.toString()}");
          debugPrint("EventList: ${assignmentList[0].subject}");
        }));
    setState(() {
      loading = false;
    });
    // final allData = querySnapshot.docs.map((doc) => doc.data());
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
                const CustomAppBar(title: "Assignment"),
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
                                    itemCount: assignmentList.length,
                                    itemBuilder: (context, index) {
                                      return AssignmentCard(
                                        subject: assignmentList[index].subject,
                                        chapter: assignmentList[index].topic,
                                        assignDate:
                                            assignmentList[index].assignDate,
                                        submissionDate:
                                            assignmentList[index].lastDate,
                                        submitted:
                                            assignmentList[index].isSubmitted,
                                      );
                                    },
                                  ),
                                  // const AssignmentCard(
                                  //     subject: "Mathematics",
                                  //     assignDate: "2 Jan 2024",
                                  //     submissionDate: "10 March 24",
                                  //     chapter: "Surface Areas and Volumes"),
                                  // AssignmentCard(
                                  //     subject: "Science",
                                  //     assignDate: "10 Jan 2024",
                                  //     submissionDate: "15 March 24",
                                  //     paymentMode: "Online",
                                  //     chapter: "Structure of Atoms"),
                                  // AssignmentCard(
                                  //     subject: "English",
                                  //     assignDate: "20 Jan 2024",
                                  //     submissionDate: "17 March 24",
                                  //     paymentMode: "Card",
                                  //     chapter: "My Bestfriend Essay"),
                                  // AssignmentCard(
                                  //     subject: "English",
                                  //     assignDate: "20 Jan 2024",
                                  //     submissionDate: "17 March 24",
                                  //     paymentMode: "Card",
                                  //     chapter: "My Bestfriend Essay"),
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
