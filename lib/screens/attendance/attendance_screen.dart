import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewAttendanceScreen extends StatefulWidget {
  const ViewAttendanceScreen({super.key});

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  final CollectionReference attendanceCollection =
  FirebaseFirestore.instance.collection('attendance');

  Map<String, List<Map<String, dynamic>>> _groupedAttendance = {};
  Map<String, double> _subjectAttendancePercentage = {}; // Stores attendance percentage per subject
  bool _isLoading = false;
  bool _hasSearched = false;
  String? enrollmentNumber;

  @override
  void initState() {
    super.initState();
    _fetchUserEnrollment(); // Fetch user data when screen is initialized
  }

  Future<void> _fetchUserEnrollment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          if (userData.containsKey('enrollment_number')) {
            enrollmentNumber = userData['enrollment_number'];

            // Fetch attendance for the user if enrollment number exists
            if (enrollmentNumber != null && enrollmentNumber!.isNotEmpty) {
              await _fetchStudentAttendance(enrollmentNumber!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enrollment number not found in user profile")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Field 'enrollment_number' not found in user document")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User profile not found in Firestore")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user profile: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  String capitalize(String status) {
    return status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
  }

  Future<void> _fetchStudentAttendance(String enrollmentNumber) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      QuerySnapshot snapshot = await attendanceCollection
          .where('enrollment', isEqualTo: enrollmentNumber)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No attendance records found for this enrollment number.");
      }

      Map<String, List<Map<String, dynamic>>> groupedAttendance = {};
      Map<String, int> totalClassesPerSubject = {}; // Total classes per subject
      Map<String, int> attendedClassesPerSubject = {}; // Attended classes per subject

      for (var doc in snapshot.docs) {
        Map<String, dynamic> attendanceData = doc.data() as Map<String, dynamic>;
        String subject = attendanceData['subject'] ?? 'Unknown';
        String status = attendanceData['status']?.toString().trim().toLowerCase() ?? '';
        String date = attendanceData['date'] ?? '';

        // Group by subject
        if (!groupedAttendance.containsKey(subject)) {
          groupedAttendance[subject] = [];
          totalClassesPerSubject[subject] = 0;
          attendedClassesPerSubject[subject] = 0;
        }

        groupedAttendance[subject]?.add({
          'date': date,
          'status': capitalize(status), // Capitalize the status before adding
        });

        totalClassesPerSubject[subject] = totalClassesPerSubject[subject]! + 1;

        if (status == 'present') {
          attendedClassesPerSubject[subject] = attendedClassesPerSubject[subject]! + 1;
        }
      }

      // Calculate the attendance percentage for each subject
      Map<String, double> subjectAttendancePercentage = {};
      totalClassesPerSubject.forEach((subject, totalClasses) {
        int attendedClasses = attendedClassesPerSubject[subject] ?? 0;
        double percentage = totalClasses > 0 ? (attendedClasses / totalClasses) * 100 : 0.0;
        subjectAttendancePercentage[subject] = percentage;
      });

      setState(() {
        _groupedAttendance = groupedAttendance;
        _subjectAttendancePercentage = subjectAttendancePercentage;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching attendance: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isLoading) const CircularProgressIndicator(),
            if (_hasSearched && !_isLoading && _groupedAttendance.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _groupedAttendance.keys.length,
                  itemBuilder: (context, index) {
                    String subject = _groupedAttendance.keys.elementAt(index);
                    List<Map<String, dynamic>> attendanceRecords =
                    _groupedAttendance[subject]!;
                    double subjectPercentage = _subjectAttendancePercentage[subject] ?? 0.0;

                    return ExpansionTile(
                      title: Text("Subject: $subject"),
                      subtitle: Text(
                        "Attendance Percentage: ${subjectPercentage.toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      children: attendanceRecords.map((record) {
                        return ListTile(
                          title: Text("Date: ${record['date']}"),
                          subtitle: Text("Status: ${capitalize(record['status'])}"),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            if (_hasSearched && !_isLoading && _groupedAttendance.isEmpty)
              const Text("No attendance records found."),
          ],
        ),
      ),
    );
  }
}
