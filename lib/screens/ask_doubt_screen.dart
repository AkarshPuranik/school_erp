import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/components/buttom_vector_image.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/components/heading.dart';
import 'package:school_erp/components/required_text.dart';
import 'package:school_erp/components/star_background.dart';
import 'package:school_erp/components/submit_button.dart';
import 'package:school_erp/components/textfield.dart';
import 'package:school_erp/constants/colors.dart';

import '../model/user_model.dart';

class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedSubject;
  List<String> subjectCodeList = [];
  List<String> subjectList = [];

  // Firestore initialization
  CollectionReference doubtCollection =
      FirebaseFirestore.instance.collection('doubts');
  CollectionReference syllabusCollection =
      FirebaseFirestore.instance.collection('syllabus');
  CollectionReference subjectsCollection =
      FirebaseFirestore.instance.collection('subjects');

  Box<UserModel> userBox = Hive.box<UserModel>('users');

  bool subjectError = false;
  bool titleError = false;
  bool descriptionError = false;

  @override
  void initState() {
    fetchSubjects();
    super.initState();
  }

  Future<void> fetchSubjects() async {
    await syllabusCollection
        .where("semester", isEqualTo: userBox.get("user")?.semester)
        .where("section", isEqualTo: userBox.get("user")?.section)
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                subjectCodeList = List.from(element["subjects"]);
                debugPrint("Subject: ${subjectCodeList[0]}");
              });
              debugPrint("EventList: ${subjectCodeList.toString()}");
            }));

    for (var subject in subjectCodeList) {
      await subjectsCollection
          .where("subject_code", isEqualTo: subject)
          .get()
          .then((value) => {
                setState(() {
                  subjectList
                      .add("$subject - ${value.docs[0]['subject_name']}");
                }),
              });
    }
  }

  // String? _errorText() {
  //   final text = titleController.value.text;
  //
  //   if (text.isEmpty) {
  //     return "Required *";
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSubject != null) {
      setState(() {
        subjectError = false;
      });
    }
    if (titleController.value.text.isNotEmpty) {
      setState(() {
        titleError = false;
      });
    }
    if (descriptionController.value.text.isNotEmpty) {
      setState(() {
        descriptionError = false;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Ask Doubt"),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              const CommonTitle(
                                title: "Select Subject",
                                required: true,
                              ),
                              DropdownButton2(
                                  items: subjectList
                                      .map(
                                        (String item) =>
                                            DropdownMenuItem<String>(
                                          value: item,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.fromLTRB(
                                                14.0,
                                                item == subjectList[0]
                                                    ? 0.0
                                                    : 12.0,
                                                0,
                                                7.0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: subjectList
                                                                    .indexOf(
                                                                        item) ==
                                                                0
                                                            ? Colors.transparent
                                                            : Colors.black12,
                                                        width: 1))),
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  isExpanded: true,
                                  menuItemStyleData: const MenuItemStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                  value: selectedSubject,
                                  dropdownStyleData: DropdownStyleData(
                                      maxHeight: 210,
                                      scrollPadding: const EdgeInsets.symmetric(
                                          vertical: 0.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      )),
                                  selectedItemBuilder: (BuildContext ctxt) {
                                    return subjectList.map<Widget>((item) {
                                      return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ));
                                    }).toList();
                                  },
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedSubject = newValue;
                                    });
                                  }),
                              if (subjectError) const RequiredText(),
                              const SizedBox(height: 30.0),
                              const CommonTitle(
                                title: "Title",
                                required: true,
                              ),
                              CommonTextField(
                                controller: titleController,
                                textInputAction: TextInputAction.next,
                              ),
                              if (titleError) const RequiredText(),
                              const SizedBox(height: 30.0),
                              const CommonTitle(
                                title: "Description",
                                required: true,
                              ),
                              CommonTextField(
                                controller: descriptionController,
                                textInputAction: TextInputAction.done,
                              ),
                              if (descriptionError) const RequiredText(),
                              const SizedBox(height: 40.0),
                              SubmitButton(
                                  buttonText: "SEND",
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (selectedSubject == null) {
                                      setState(() {
                                        subjectError = true;
                                      });
                                    }
                                    if (titleController.text.isEmpty) {
                                      setState(() {
                                        titleError = true;
                                      });
                                    }
                                    if (descriptionController.text.isEmpty) {
                                      setState(() {
                                        descriptionError = true;
                                      });
                                    }
                                    if (selectedSubject != null &&
                                        titleController.text.isNotEmpty &&
                                        descriptionController.text.isNotEmpty) {
                                      doubtCollection.add({
                                        "semester":
                                            userBox.get("user")?.semester,
                                        "subject": selectedSubject,
                                        "title":
                                            titleController.text.toString(),
                                        "description": descriptionController
                                            .text
                                            .toString(),
                                      }).then((value) => {
                                            Navigator.pop(context),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  "Doubt Submitted",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                closeIconColor: Colors.white,
                                                showCloseIcon: true,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    const Color(0xFF2855AE)
                                                        .withOpacity(0.9),
                                              ),
                                            ),
                                          });
                                    }
                                  }),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
            const BottomVectorImage(),
          ],
        ),
      ),
    );
  }
}
