import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class UploadAttendanceScreen extends StatefulWidget {
  const UploadAttendanceScreen({super.key});

  @override
  State<UploadAttendanceScreen> createState() => _UploadAttendanceScreenState();
}

class _UploadAttendanceScreenState extends State<UploadAttendanceScreen> {
  final CollectionReference attendanceCollection =
  FirebaseFirestore.instance.collection('attendance');

  final TextEditingController _enrollmentController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  String? _selectedSubject;
  String? _attendanceStatus; // "Present" or "Absent"
  DateTime _selectedDate = DateTime.now(); // Default to current date
  bool _isLoading = false;

  // List of subjects for the dropdown
  final List<String> subjects = [
    'Maths',
    'Science',
    'Social',
    'Hindi',
    'English'
  ];

  Future<void> _uploadAttendance() async {
    if (_selectedSubject == null ||
        _enrollmentController.text.isEmpty ||
        _attendanceStatus == null ||
        _classController.text.isEmpty ||
        _sectionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await attendanceCollection.add({
        'subject': _selectedSubject, // Selected subject from dropdown
        'enrollment': _enrollmentController.text,
        'status': _attendanceStatus?.trim(), // Store capitalized attendance status
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate), // Use selected date
        'class': _classController.text,
        'section': _sectionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance uploaded successfully!")),
      );

      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading attendance: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFields() {
    _enrollmentController.clear();
    _classController.clear();
    _sectionController.clear();
    _selectedSubject = null;
    _attendanceStatus = null;
    _selectedDate = DateTime.now(); // Reset date to today
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Current date as default
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _enrollmentController.dispose();
    _classController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(
                labelText: "Select Subject",
                border: OutlineInputBorder(),
              ),
              items: subjects.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSubject = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _enrollmentController,
              decoration: const InputDecoration(
                labelText: "Student Enrollment Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Buttons for selecting attendance status (Present or Absent)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _attendanceStatus = 'Present'; // Capitalized
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _attendanceStatus == 'Present'
                        ? Colors.green
                        : Colors.grey,
                  ),
                  child: const Text("Present"), // Capitalized Present
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _attendanceStatus = 'Absent'; // Capitalized
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _attendanceStatus == 'Absent'
                        ? Colors.red
                        : Colors.grey,
                  ),
                  child: const Text("Absent"), // Capitalized Absent
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Date Picker for selecting date
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Selected Date",
                      hintText: DateFormat('yyyy-MM-dd')
                          .format(_selectedDate), // Display selected date
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () => _selectDate(context), // Open date picker
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Open date picker
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _classController,
              decoration: const InputDecoration(
                labelText: "Class",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: "Section",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _uploadAttendance,
              child: const Text("Upload Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
