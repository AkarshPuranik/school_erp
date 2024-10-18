import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _enrollmentNumber = '';
  String _profileImageUrl = '';
  File? _profileImage; // Profile image file

  // Controllers for user input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // Image picker
  User? _currentUser; // Firebase user
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(); // Fetch the current authenticated user
  }

  @override
  void dispose() {
    // Dispose of the controllers
    _nameController.dispose();
    _enrollmentController.dispose();
    _sectionController.dispose();
    _dobController.dispose();
    _contactController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _addressController.dispose();
    _classController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      await _fetchUserData(); // Fetch user profile data from Firestore
    }
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('profile_history')
            .doc(_currentUser!.uid) // Using UID as document ID
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _userName = userData['name'] ?? 'NA';
            _enrollmentNumber = userData['enrollmentNumber'] ?? 'Not available';
            _profileImageUrl = userData['profileImageUrl'] ?? '';

            // Populate text fields
            _nameController.text = userData['name'] ?? '';
            _enrollmentController.text = userData['enrollmentNumber'] ?? '';
            _sectionController.text = userData['section'] ?? '';
            _dobController.text = userData['dateOfBirth'] ?? '';
            _contactController.text = userData['contactNumber'] ?? '';
            _fatherNameController.text = userData['fatherName'] ?? '';
            _motherNameController.text = userData['motherName'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _classController.text = userData['class'] ?? '';
          });
        } else {
          print("No document found for the current user.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${_currentUser!.uid}.jpg');
      await storageRef.putFile(_profileImage!);
      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl; // Set the download URL
      });
    } catch (e) {
      print("Error uploading profile image: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _storeUserProfile() async {
    if (_currentUser == null) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // Upload profile image if selected
      if (_profileImage != null) {
        await _uploadProfileImage();
      }

      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('profile_history')
          .doc(_currentUser!.uid); // Using UID as document ID

      // Store updated profile data
      await userDocRef.set({
        'name': _nameController.text,
        'enrollmentNumber': _enrollmentController.text,
        'section': _sectionController.text,
        'dateOfBirth': _dobController.text,
        'contactNumber': _contactController.text,
        'fatherName': _fatherNameController.text,
        'motherName': _motherNameController.text,
        'address': _addressController.text,
        'class': _classController.text,
        'profileImageUrl': _profileImageUrl,
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error storing student data: $e");
    }
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty ||
        _enrollmentController.text.isEmpty ||
        _sectionController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _fatherNameController.text.isEmpty ||
        _motherNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _classController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to save your changes?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pushReplacementNamed(
                    context, '/home'); // User confirms
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile image
              GestureDetector(
                onTap: () async {
                  final ImageSource? source = await showDialog<ImageSource>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Select Image Source"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(ImageSource.camera);
                            },
                            child: const Text("Camera"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(ImageSource.gallery);
                            },
                            child: const Text("Gallery"),
                          ),
                        ],
                      );
                    },
                  );

                  if (source != null) {
                    final XFile? image =
                        await _picker.pickImage(source: source);
                    setState(() {
                      if (image != null) {
                        _profileImage = File(image.path);
                      } else {
                        _profileImage = null;
                      }
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? Image.file(_profileImage!).image
                      : _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : null,
                  child: _profileImage != null
                      ? null
                      : _profileImageUrl.isNotEmpty
                          ? null
                          : Icon(Icons.add_a_photo, size: 30),
                ),
              ),
              const SizedBox(height: 20),

              // User input fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _enrollmentController,
                decoration: const InputDecoration(
                  labelText: 'Enrollment Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(
                  labelText: 'class',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'section',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons
                      .calendar_today), // Calendar icon to indicate date picker
                ),
                readOnly: true, // Make the field read-only
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Date of Birth'),
                        content: Container(
                          // Ensuring the date picker fits within the dialog
                          width: double.maxFinite,
                          height:
                              350, // Adjust height if needed to fit your layout
                          child: SfDateRangePicker(
                            selectionMode: DateRangePickerSelectionMode.single,
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              setState(() {
                                if (args.value != null) {
                                  DateTime selectedDate = args.value;
                                  _dobController.text = selectedDate
                                      .toLocal()
                                      .toString()
                                      .split(
                                          ' ')[0]; // Formatting as YYYY-MM-DD
                                }
                              });
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Father\'s Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _motherNameController,
                decoration: const InputDecoration(
                  labelText: 'Mother\'s Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (_validateFields()) {
                      // Show confirmation dialog
                      bool? confirm = await _showConfirmationDialog();
                      if (confirm == true) {
                        await _storeUserProfile(); // Store user profile on save
                        Navigator.pop(context, {
                          'username': _nameController.text,
                          'enrollmentNumber': _enrollmentController.text,
                          'classyear': _classController.text,
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields."),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 140,
                        right: 140,
                        top: 10,
                        bottom: 10), // Add some margin around the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 7.0), // Reduce the padding
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20.0), // Reduce the border radius
                      color: const Color.fromARGB(255, 214, 174, 222),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the text horizontally
                      children: [
                        Icon(Icons.check, size: 18.0), // Reduce the icon size
                        const SizedBox(
                            width:
                                2.0), // Reduce the space between the icon and the text
                        Text("DONE",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.bold)), // Reduce the text size
                      ],
                    ),
                  ),
                ),
              ),
              // Save button
            ],
          ),
        ),
      ),
    );
  }
}
