import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/constants/colors.dart';
import 'package:school_erp/model/user_model.dart';
import 'package:school_erp/reusable_widgets/home_screen_cards/master_card.dart';
import 'package:school_erp/reusable_widgets/home_screen_cards/small_card.dart';
import 'package:school_erp/reusable_widgets/loader.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_attendance.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_change_password.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_profile_page.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_setting_screen.dart';
import 'package:school_erp/screens/fees_due_screen.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  String username = '';
  String section = '';
  String classyear = '';
  String _profileImageUrl = '';
  String email = '';

  Future<void> _fetchUserProfile() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('teachers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('profile_history')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final userDoc = await userDocRef.get();

    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _profileImageUrl = userData['profileImageUrl'];
        username = userData['name'];
        section = userData['section'];
        classyear = userData['class'];
        email = userData['email'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
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
            SingleChildScrollView(
              // Wrapped content with SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi,\n$username",
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$email",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                "classteacher of:$classyear-$section",
                                style: const TextStyle(
                                  color: Color(0xFF6184C7),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TeacherSettingScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImageUrl.isNotEmpty
                                ? NetworkImage(_profileImageUrl)
                                : null,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const UploadAttendanceScreen(),
                                  ),
                                );
                              },
                              child: const HomeScreenMasterCard(
                                attendance: true,
                                tooltext: 'students attendance',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FeesDueScreen(),
                                  ),
                                );
                              },
                              child: const HomeScreenMasterCard(
                                tooltext: 'Check you fee due here ',
                                attendance: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Wrap(
                          runAlignment: WrapAlignment.spaceBetween,
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 20.0,
                          spacing: 20.0,
                          children: [
                            HomeScreenSmallCard(
                              tooltext:
                                  'Check out your marks by tapping the button',
                              icon: Icons.collections_bookmark_rounded,
                              buttonText: "Marks",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Feature coming soon...",
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
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
