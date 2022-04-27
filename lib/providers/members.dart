// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/material.dart';

import '../providers/user.dart';

class Members with ChangeNotifier {
  final List<User> _membersList = [
    User(
        id: 'm1',
        name: 'Taran Jyot Singh',
        phoneNumber: 9213041313,
        image: File('assets/images/TJ.jpg'),
        designation: 'Core Member'),
    User(
        id: 'm2',
        name: 'KA',
        phoneNumber: 9213041313,
        image: File('assets/images/KA.jpg'),
        designation: 'Member'),
    User(
        id: 'm3',
        name: 'NJ',
        phoneNumber: 9213041313,
        image: File('assets/images/NJ.jpg'),
        designation: 'Core Member'),
  ];

  List<User> get membersList {
    return [..._membersList];
  }

  final List<String> _selectedList = [];

  List<String> get selectedList {
    return [..._selectedList];
  }

  void addnewMember(User newMember) {
    _membersList.add(newMember);

    notifyListeners();
  }

  void deleteMember() {
    // **************Delete one Item***************
    // final existingMemberIndex =
    //     _membersList.indexWhere((member) => member.id == id);
    //var existingMember = _membersList[existingMemberIndex];
    // _membersList.removeAt(existingMemberIndex);
    // ********************************************
    // final existingSelectedMemberIndex =
    //     _selectedList.indexWhere((member) => member.id == id);
    // for (int i = 0; i < _selectedList.length - 1; i++) {
    //   _membersList
    //       .removeWhere((member) => member.id == existingSelectedMemberIndex);
    // }

    _selectedList.forEach((element) {
      _membersList.removeWhere((member) => member.id == element);
    });
    //print(element);
    _selectedList.clear();
    notifyListeners();
  }

  void addMemberIDInSelectedList(String id) {
    if (_selectedList.any((existingID) => existingID == id)) {
      _selectedList.removeWhere((existingID) => existingID == id);
      notifyListeners();
      return;
    }
    // print(_selectedList.any((member) => member.id == id));
    _selectedList.add(id);

    //_selectedList.forEach((element) => print(element),);
    notifyListeners();
  }

  // void removeMemberFromSelectedList(String id) {
  //   final existingMemberIndex =
  //       _selectedList.indexWhere((member) => member.id == id);
  //   _selectedList.removeAt(existingMemberIndex);
  //   notifyListeners();
  // }
}
