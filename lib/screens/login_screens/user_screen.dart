import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_create_account.dart';
import 'package:school_erp/screens/Teacher_screens.dart/teacher_home_screen.dart';
import 'package:school_erp/screens/student_screens/home_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool? _selectedDoctor;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool isStudent = true; // Track if the user is a student or teacher

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (isStudent) {
        // Fetch email associated with the enrollment number from Firestore
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('enrollment_number', isEqualTo: _enrollmentController.text.trim())
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Get the email corresponding to the enrollment number
          var email = snapshot.docs.first.get('email');

          // Proceed with login using the email fetched from Firestore
          UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: _passwordController.text.trim(),
          );

          // Navigate to HomeScreen on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          // Enrollment number not found in Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Enrollment number not found")),
          );
        }
      } else {
        // Proceed with login using the email and password
        try {
          UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Check if the teacher exists in the 'teachers' collection
          var teacherSnapshot = await FirebaseFirestore.instance
              .collection('teachers')
              .where('email', isEqualTo: _emailController.text.trim())
              .get();

          if (teacherSnapshot.docs.isNotEmpty) {
            // Navigate to TeacherHomeScreen on successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TeacherHomeScreen()),
            );
          } else {
            // Teacher not found in Firestore
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Teacher not found")),
            );
            // Sign out the user
            await _auth.signOut();
          }
        } catch (e) {
          // Handle login error
          if (e is FirebaseAuthException) {
            if (e.code == 'invalid-email') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid email")),
              );
            } else if (e.code == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Wrong password")),
              );
            } else if (e.code == 'user-not-found') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User not found")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Login failed: $e")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("An error occurred: $e")),
            );
          }
        }
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
      appBar: AppBar(
        title: const Text('Choose Account Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDoctor = true;
                        isStudent = true; // Set isStudent to true when Student is selected
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedDoctor == true ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/download.png', // Replace with your student image
                            height: 140.0,
                            width: 140.0,
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Student',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _selectedDoctor == true
                              ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check, color: Colors.white, size: 15),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDoctor = false;
                        isStudent = false; // Set isStudent to false when Teacher is selected
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedDoctor == false ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/8065183.png', // Replace with your teacher image
                            height: 140.0,
                            width: 140.0,
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Teacher',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _selectedDoctor == false
                              ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check, color: Colors.white, size: 15),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              if (_selectedDoctor != null) ...[
                TextFormField(
                  controller: isStudent ? _enrollmentController : _emailController,
                  decoration: InputDecoration(
                    labelText: isStudent ? 'Enrollment Number' : 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
