import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:school_erp/reusable_widgets/loader.dart';
import '../../components/buttom_vector_image.dart';
import '../../components/custom_appbar.dart';
import '../../components/heading.dart';
import '../../components/required_text.dart';
import '../../components/star_background.dart';
import '../../components/submit_button.dart';
import '../../components/textfield.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  //TextField controllers initializations
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //Error text boolean initializations
  bool titleError = false;
  bool timeError = false;
  bool descriptionError = false;

  //Stores selected time and date and passes to firebase
  String time = "";

  //Firebase collection initialization
  CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  //Image picker initialization (Event image/poster)
  XFile? _image;
  UploadTask? uploadTask;

  //This variable will store the URL of uploaded image
  String? imageURL;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();
    _image = await picker.pickImage(source: ImageSource.gallery);

    // if(result == null) {
    //   return;
    // } else {
    //   // setState(() {
    //   //   pickedFile = result.files.first;
    //   // });
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Create Event"),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height / 1.1,
                    margin: const EdgeInsets.only(top: 30.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)),
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.165,
                            child: BottomVectorImage(),
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.manual,
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5.0),
                                      Center(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: _image == null
                                              ? Center(
                                                  child: GestureDetector(
                                                    onTap: () => pickImage(),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12.0,
                                                          horizontal: 22.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white54,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: const Text(
                                                        "UPLOAD",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Image.file(
                                                  File(_image!.path),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 40.0),
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
                                        title: "Time",
                                        required: true,
                                      ),
                                      CommonTextField(
                                        controller: timeController,
                                        textInputAction: TextInputAction.done,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          ).then((selectedDate) {
                                            // After selecting the date, display the time picker.
                                            if (selectedDate != null) {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ).then((selectedTime) {
                                                // Handle the selected date and time here.
                                                debugPrint(
                                                    "Selected Date: $selectedDate");
                                                if (selectedTime != null) {
                                                  DateTime selectedDateTime =
                                                      DateTime(
                                                    selectedDate.year,
                                                    selectedDate.month,
                                                    selectedDate.day,
                                                    selectedTime.hour,
                                                    selectedTime.minute,
                                                  );
                                                  debugPrint(
                                                      "Selected DateTime: $selectedDateTime"); // You can use the selectedDateTime as needed.
                                                  debugPrint(
                                                      "Selected Date: ${DateFormat('dd LLL yy').format(selectedDate)}");
                                                  debugPrint(
                                                      "selected Time: ${DateFormat('dd LLL yy').format(selectedDate)}, ${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name.toUpperCase()}");

                                                  setState(() {
                                                    timeController.text =
                                                        "${DateFormat('dd LLL yy').format(selectedDate)}, ${selectedTime.hourOfPeriod}:${selectedTime.minute} ${selectedTime.period.name.toUpperCase()}";
                                                    FocusScope.of(context)
                                                        .nextFocus();
                                                  });
                                                }
                                              });
                                            }
                                          });
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                      if (timeError) const RequiredText(),
                                      const SizedBox(height: 30.0),
                                      const CommonTitle(
                                        title: "Description",
                                        required: true,
                                      ),
                                      CommonTextField(
                                        controller: descriptionController,
                                        textInputAction: TextInputAction.done,
                                        maxLines: 3,
                                      ),
                                      if (descriptionError)
                                        const RequiredText(),
                                      const SizedBox(height: 40.0),
                                      SubmitButton(
                                          buttonText: "SEND",
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            if (titleController.text.isEmpty) {
                                              setState(() {
                                                titleError = true;
                                              });
                                            }
                                            if (timeController.text.isEmpty) {
                                              setState(() {
                                                timeError = true;
                                              });
                                            }
                                            if (descriptionController
                                                .text.isEmpty) {
                                              setState(() {
                                                descriptionError = true;
                                              });
                                            }
                                            if (timeController
                                                    .text.isNotEmpty &&
                                                titleController
                                                    .text.isNotEmpty &&
                                                descriptionController
                                                    .text.isNotEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          const LoaderDialog());

                                              if (_image != null) {
                                                final storageRef = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(
                                                        "event_poster/${_image!.name}");
                                                uploadTask = storageRef.putFile(
                                                    File(_image!.path));

                                                final snapshot =
                                                    await uploadTask
                                                        ?.whenComplete(() {});

                                                imageURL = await snapshot?.ref
                                                    .getDownloadURL();

                                                setState(() {});
                                              }

                                              eventsCollection.add({
                                                "title": titleController.text
                                                    .toString(),
                                                "description":
                                                    descriptionController.text
                                                        .toString(),
                                                "time": timeController.text
                                                    .toString(),
                                                "image": imageURL ?? "",
                                              }).then((value) => {
                                                    Navigator.pop(context),
                                                    Navigator.pop(context),
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          "Event Created Successfully",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)),
                                                        closeIconColor:
                                                            Colors.white,
                                                        showCloseIcon: true,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            const Color(
                                                                    0xFF2855AE)
                                                                .withOpacity(
                                                                    0.9),
                                                      ),
                                                    ),
                                                  });
                                            }
                                          }),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // const BottomVectorImage(),
          ],
        ),
      ),
    );
  }
}
