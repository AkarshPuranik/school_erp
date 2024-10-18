import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_erp/components/plain_background.dart';
import 'package:school_erp/components/textfield.dart';
import 'package:school_erp/screens/login_screens/user_screen.dart';
import 'package:school_erp/screens/student_screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Add Firestore instance
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Check if email is valid
      if (!emailController.text.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check if password is strong enough
      if (passwordController.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Password must be at least 8 characters")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check if enrollment number already exists
      var snapshot = await _firestore
          .collection('users')
          .where('enrollment_number',
              isEqualTo: enrollmentController.text.trim())
          .get();
      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enrollment number already exists")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Perform signup
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save enrollment number and email in Firestore
      String enrollmentNumber = enrollmentController.text.trim();
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'enrollment_number': enrollmentNumber,
        'email': emailController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });

      // Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      // Handle signup error
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password is too weak")),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email already in use")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Signup failed: $e")),
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
                  // Enrollment Number field
                  CommonTextField(
                    controller: enrollmentController,
                    hintText: "Enrollment Number",
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: emailController,
                    hintText: "Email",
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  CommonTextField(
                    controller: passwordController,
                    isPassword: true,
                    hintText: "Password",
                    obscureText: true,
                    textStyle: const TextStyle(color: Colors.white),
                    hintTextStyle: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signup,
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
          ],
        ),
      ),
    );
  }
}
