import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_erp/screens/change_password_screen.dart';
import '../model/user_model.dart';
import '../reusable_widgets/loader.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = '';
  String enrollmentNumber = '';
  String profileImageUrl = ''; // For storing profile image URL

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user data from Hive box
  void fetchUserData() {
    final userBox = Hive.box<UserModel>('users');
    final user = userBox.get("user"); // Assuming 'user' is the key

    if (user != null) {
      setState(() {
        userName = user.name ?? 'Unknown User';
        enrollmentNumber = user.enrollmentNumber ?? 'Not Available';
        profileImageUrl = user.profileImageUrl ?? ''; // Get profile image URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const Divider(
            height: 1.0,
            thickness: 1.0,
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Display the profile image using CircleAvatar
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl) // Display image from URL
                          : null, // Default image if profileImageUrl is empty
                      child: profileImageUrl.isEmpty
                          ? const Icon(Icons.person, size: 35) // Placeholder icon
                          : null,
                    ),
                    const SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName, // Display the dynamic name
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          enrollmentNumber, // Display the dynamic enrollment number
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                const SizedBox(height: 10.0),
                SettingsOption(
                  optionName: "Edit Profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                SettingsOption(
                  optionName: "Change Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
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
                          content: const Text("Are you sure you want to logout?"),
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
                                // Clear user data from Hive and navigate to login
                                Hive.box<UserModel>('users').clear().then(
                                      (value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
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
                            borderRadius: BorderRadius.circular(8.0)),
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
                            borderRadius: BorderRadius.circular(8.0)),
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

  const SettingsOption({super.key, required this.optionName, required this.onTap});

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
