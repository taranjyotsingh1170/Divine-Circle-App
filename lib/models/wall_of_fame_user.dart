import 'dart:io';

class WallOfFameUser {
  String id;
  String name;
  int phoneNumber;
  File image;
  String designation;

  WallOfFameUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.designation,
  });
}
