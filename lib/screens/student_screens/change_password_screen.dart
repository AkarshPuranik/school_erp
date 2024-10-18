import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:school_erp/components/buttom_vector_image.dart';
import 'package:school_erp/components/custom_appbar.dart';
import 'package:school_erp/components/heading.dart';
import 'package:school_erp/components/star_background.dart';
import 'package:school_erp/components/submit_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to change password
  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String reenterPassword = _reenterPasswordController.text;

    // Check if new password matches re-entered password
    if (newPassword != reenterPassword) {
      _showMessage("Passwords do not match!");
      return;
    }

    // Get the current user
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Password Changed"),
              content: Text("Your password has been changed successfully."),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context)
                        .pushReplacementNamed('/home'); // Return to home screen
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        _showMessage("Failed to change password: $e");
      }
    } else {
      _showMessage("No user is currently logged in.");
    }
  }

  // Helper function to show messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            const StarBackground(),
            Column(
              children: [
                const CustomAppBar(title: "Change Password"),
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
                            const CommonTitle(title: "Old Password"),
                            TextField(
                              controller: _oldPasswordController,
                              obscureText: true, // Hide input for passwords
                              cursorColor: const Color(0xFF2855AE),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            const CommonTitle(title: "New Password"),
                            TextField(
                              controller: _newPasswordController,
                              obscureText: true, // Hide input for passwords
                              cursorColor: const Color(0xFF2855AE),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            const CommonTitle(title: "Re-enter Password"),
                            TextField(
                              controller: _reenterPasswordController,
                              obscureText: true, // Hide input for passwords
                              cursorColor: const Color(0xFF2855AE),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2855AE)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            SubmitButton(
                              buttonText: "CHANGE PASSWORD",
                              onTap: _changePassword, // Trigger password change
                            ),
                          ],
                        ),
                      ),
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
