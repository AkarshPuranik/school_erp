import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String enrollmentNumber = '';
  String profileImageUrl = '';
  File? _profileImage; // For storing the selected profile image

  final TextEditingController nameController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc('user_id').get();
      final userData = userDoc.data();
      if (userData != null) {
        setState(() {
          userName = userData['name'] ?? 'NA';
          enrollmentNumber = userData['enrollmentNumber'] ?? 'Not available';
          profileImageUrl = userData['profileImageUrl'] ?? '';
          nameController.text = userData['name'] ?? '';
          enrollmentController.text = userData['enrollmentNumber'] ?? '';
          branchController.text = userData['branch'] ?? '';
          dobController.text = userData['dateOfBirth'] ?? '';
          contactController.text = userData['contactNumber'] ?? '';
          fatherNameController.text = userData['fatherName'] ?? '';
          motherNameController.text = userData['motherName'] ?? '';
          addressController.text = userData['address'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> uploadProfileImage() async {
    if (_profileImage == null) return;

    try {
      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/user_id.jpg');
      await storageRef.putFile(_profileImage!);
      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        profileImageUrl = downloadUrl; // Set the download URL after upload completes
      });
    } catch (e) {
      print("Error uploading profile image: $e");
      throw e; // Rethrow error to propagate it to the calling function
    }
  }

  Future<void> storeUserProfile() async {
    try {
      // First, upload the profile image (if selected)
      if (_profileImage != null) {
        await uploadProfileImage(); // Ensure image upload completes
      }

      // Store the updated profile data in Firestore after image upload
      await FirebaseFirestore.instance.collection('users').doc('user_id').set({
        'name': nameController.text,
        'enrollmentNumber': enrollmentController.text,
        'branch': branchController.text,
        'dateOfBirth': dobController.text,
        'contactNumber': contactController.text,
        'fatherName': fatherNameController.text,
        'motherName': motherNameController.text,
        'address': addressController.text,
        'profileImageUrl': profileImageUrl, // Store the uploaded image URL
      });
      print("Profile data stored successfully.");
    } catch (e) {
      print("Error storing user profile: $e");
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await storeUserProfile(); // Store user profile on save
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 25.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "DONE",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          children: [
                            GestureDetector(
                              onTap: selectImage, // Open image picker
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : (profileImageUrl.isNotEmpty
                                    ? NetworkImage(profileImageUrl)
                                    : null) as ImageProvider?, // Display image
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(labelText: "Name"),
                            ),
                            TextField(
                              controller: enrollmentController,
                              decoration: const InputDecoration(labelText: "Enrollment Number"),
                            ),
                            TextField(
                              controller: branchController,
                              decoration: const InputDecoration(labelText: "Branch"),
                            ),
                            TextField(
                              controller: dobController,
                              decoration: const InputDecoration(labelText: "Date of Birth"),
                            ),
                            TextField(
                              controller: contactController,
                              decoration: const InputDecoration(labelText: "Contact Number"),
                            ),
                            TextField(
                              controller: fatherNameController,
                              decoration: const InputDecoration(labelText: "Father Name"),
                            ),
                            TextField(
                              controller: motherNameController,
                              decoration: const InputDecoration(labelText: "Mother Name"),
                            ),
                            TextField(
                              controller: addressController,
                              decoration: const InputDecoration(labelText: "Address"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
