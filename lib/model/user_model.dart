import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Hive generated file

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? enrollmentNumber;

  @HiveField(2)
  String? academicYear;

  @HiveField(3)
  String? branch;

  @HiveField(4)
  String? dateOfBirth;

  @HiveField(5)
  String? contactNumber;

  @HiveField(6)
  String? motherName;

  @HiveField(7)
  String? fatherName;

  @HiveField(8)
  String? address;

  @HiveField(9)
  String? semester;

  @HiveField(10)
  String? email;

  @HiveField(11)
  String? profileImageUrl; // New field for profile image URL

  UserModel({
    this.name,
    this.enrollmentNumber,
    this.academicYear,
    this.branch,
    this.dateOfBirth,
    this.contactNumber,
    this.motherName,
    this.fatherName,
    this.address,
    this.semester,
    this.email,
    this.profileImageUrl,
  });

  // fromJson factory method to deserialize Firestore data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      enrollmentNumber: json['enrollment'] as String?,
      academicYear: json['academic_year'] as String?,
      branch: json['branch'] as String?,
      dateOfBirth: json['dob'] as String?,
      contactNumber: json['contact_number'] as String?,
      motherName: json['mother_name'] as String?,
      fatherName: json['father_name'] as String?,
      address: json['address'] as String?,
      semester: json['semester'] as String?,
      email: json['email'] as String?,
      profileImageUrl: json['profile_image_url'] as String?, // Handle profile image
    );
  }

  // toJson method to serialize the model to a Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'enrollment': enrollmentNumber,
      'academic_year': academicYear,
      'branch': branch,
      'dob': dateOfBirth,
      'contact_number': contactNumber,
      'mother_name': motherName,
      'father_name': fatherName,
      'address': address,
      'semester': semester,
      'email': email,
      'profile_image_url': profileImageUrl, // Serialize profile image URL
    };
  }

  @override
  String toString() {
    return 'UserModel(name: $name, enrollmentNumber: $enrollmentNumber, academicYear: $academicYear, branch: $branch, dateOfBirth: $dateOfBirth, contactNumber: $contactNumber, motherName: $motherName, fatherName: $fatherName, address: $address, semester: $semester, email: $email, profileImageUrl: $profileImageUrl)';
  }
}
