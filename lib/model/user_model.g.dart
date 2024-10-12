// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      name: fields[0] as String?,
      enrollmentNumber: fields[1] as String?,
      academicYear: fields[2] as String?,
      branch: fields[3] as String?,
      dateOfBirth: fields[4] as String?,
      contactNumber: fields[5] as String?,
      motherName: fields[6] as String?,
      fatherName: fields[7] as String?,
      address: fields[8] as String?,
      semester: fields[9] as String?,
      email: fields[10] as String?,
      profileImageUrl: fields[11] as String?, // New field for profile image URL
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12) // Incremented the number of fields to 12
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.enrollmentNumber)
      ..writeByte(2)
      ..write(obj.academicYear)
      ..writeByte(3)
      ..write(obj.branch)
      ..writeByte(4)
      ..write(obj.dateOfBirth)
      ..writeByte(5)
      ..write(obj.contactNumber)
      ..writeByte(6)
      ..write(obj.motherName)
      ..writeByte(7)
      ..write(obj.fatherName)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.semester)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.profileImageUrl); // Write profile image URL to Hive
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
