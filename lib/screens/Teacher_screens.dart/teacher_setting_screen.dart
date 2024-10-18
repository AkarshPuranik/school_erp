import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/constants/colors.dart';
import 'package:school_erp/model/user_model.dart';
import 'package:school_erp/reusable_widgets/loader.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_change_password.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_profile_page.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';

class TeacherSettingScreen extends StatefulWidget {
  const TeacherSettingScreen({super.key});

  @override
  State<TeacherSettingScreen> createState() => _TeacherSettingScreenState();
}

class _TeacherSettingScreenState extends State<TeacherSettingScreen> {
  String username = '';
  String section = '';
  bool isLoading = false;
  String classyear = '';
  String _profileImageUrl = '';

  Future<void> _fetchUserData() async {
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
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Box<UserModel> userBox = Hive.box<UserModel>('users');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1.0, thickness: 1.0),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : null,
                    ),
                    const SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username, // Display username
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Class teacher -$classyear$section', // Display enrollment number
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 28.0,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(thickness: 1.0, height: 1.0),
                const SizedBox(height: 10.0),
                SettingsOption(
                  optionName: "Edit Profile",
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherProfilePage(),
                      ),
                    );

                    // If the result is not null, update the username and enrollment number
                    if (result != null) {
                      setState(() {
                        username = result['name'];
                        classyear = result['class'];
                        section = result['section'];
                      });
                    }
                  },
                ),
                SettingsOption(
                  optionName: "Change Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherChangePassword(),
                      ),
                    );
                  },
                ),
                SettingsOption(
                  optionName: "Logout",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("Logout"),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const LoaderDialog(),
                                );

                                userBox.clear().then(
                                      (value) => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const UserScreen(),
                                        ),
                                        (route) => false,
                                      ),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 28.0,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "General",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(thickness: 1.0, height: 1.0),
                const SizedBox(height: 10.0),
                SettingsOption(
                  optionName: "About Us",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Coming soon...",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        closeIconColor: Colors.white,
                        showCloseIcon: true,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: primaryColor.withOpacity(0.9),
                      ),
                    );
                  },
                ),
                SettingsOption(
                  optionName: "Privacy",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Coming soon...",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        closeIconColor: Colors.white,
                        showCloseIcon: true,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: primaryColor.withOpacity(0.9),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final String optionName;
  final VoidCallback onTap;

  const SettingsOption({
    super.key,
    required this.optionName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionName,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}
