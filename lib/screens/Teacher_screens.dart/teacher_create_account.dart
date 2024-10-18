import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/components/plain_background.dart';
import 'package:school_erp/components/textfield.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_home_screen.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';
import 'package:school_erp/screens/student_screens/home_screen.dart';

class TeacherCreateAccount extends StatefulWidget {
  const TeacherCreateAccount({super.key});

  @override
  State<TeacherCreateAccount> createState() =>
      _TeacherCreateAccountScreenState();
}

class _TeacherCreateAccountScreenState extends State<TeacherCreateAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _createAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Create a new document in the 'teachers' collection in Firestore
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'designation': _designationController.text.trim(),
      });

      // Navigate to the HomeScreen on successful account creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeacherHomeScreen()),
      );
    } catch (e) {
      // Handle account creation error
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The password provided is too weak")),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("An account with this email already exists")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account creation failed: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D83C6),
      body: SafeArea(
        child: Stack(
          children: [
            const PlainBackground(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container with white background for the image
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white, // White background
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/matbuck.jpg', // Ensure correct path
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CommonTextField(
                      controller: _nameController,
                      hintText: "name",
                      textStyle: const TextStyle(color: Colors.white),
                      hintTextStyle: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    CommonTextField(
                      controller: _designationController,
                      isPassword: false,
                      hintText: "designation",
                      textStyle: const TextStyle(color: Colors.white),
                      hintTextStyle: const TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CommonTextField(
                      controller: _emailController,
                      hintText: "Email",
                      textStyle: const TextStyle(color: Colors.white),
                      hintTextStyle: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    CommonTextField(
                      controller: _passwordController,
                      isPassword: true,
                      hintText: "password",
                      obscureText: true,
                      textStyle: const TextStyle(color: Colors.white),
                      hintTextStyle: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _createAccount,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Sign Up"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UserScreen()));
                      },
                      child: Text(
                        'Back to login page?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
