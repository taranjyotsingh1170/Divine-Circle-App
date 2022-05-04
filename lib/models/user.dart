import 'dart:io';

class User {
  String id;
  String name;
  int phoneNumber;
  File image;
  String designation;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.designation,
  });
}
