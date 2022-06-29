//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/member.dart';

class Members with ChangeNotifier {
  final List<Member> _listOfMembers = [
    // Member(
    //     id: '1',
    //     email: 'test1@test.com',
    //     name: 'A',
    //     phoneNumber: 1,
    //     isInContentTeam: true,
    //     isInDesignTeam: false),
    // Member(
    //     id: '2',
    //     email: 'test2@test.com',
    //     name: 'B',
    //     phoneNumber: 1,
    //     isInDesignTeam: true,
    //     isInContentTeam: false),
    // Member(
    //     id: '3',
    //     email: 'test3@test.com',
    //     name: 'C',
    //     phoneNumber: 1,
    //     isInKirtanTeam: true),
    // Member(
    //     id: '4',
    //     email: 'test4@test.com',
    //     name: 'D',
    //     phoneNumber: 1,
    //     isInPrTeam: true,
    //     isInDesignTeam: false),
    // Member(
    //     id: '5',
    //     email: 'test5@test.com',
    //     name: 'E',
    //     phoneNumber: 1,
    //     isInContentTeam: true,
    //     isInDesignTeam: false),
    // Member(
    //     id: '6',
    //     email: 'test6@test.com',
    //     name: 'F',
    //     phoneNumber: 1,
    //     isInDesignTeam: true,
    //     isInContentTeam: false),
    // Member(
    //     id: '7',
    //     email: 'test7@test.com',
    //     name: 'G',
    //     phoneNumber: 1,
    //     isInKirtanTeam: true),
    // Member(
    //     id: '8',
    //     email: 'test8@test.com',
    //     name: 'H',
    //     phoneNumber: 1,
    //     isInContentTeam: true,
    //     isInDesignTeam: false),
  ];

  List<Member> get memberList {
    return [..._listOfMembers];
  }

  List<Member> get contentTeamMembers {
    return _listOfMembers
        .where((cmember) => cmember.isInContentTeam == true)
        .toList();
  }

  List<Member> get designTeamMembers {
    return _listOfMembers
        .where((dmember) => dmember.isInDesignTeam == true)
        .toList();
  }

  List<Member> get searchResults {
    return [..._listOfMembers];
  }

  List<Member> suggestionList(String query) {
    return searchResults.where((searchResult) {
      final result = searchResult.name.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    //return [];
  }

  void addMember(Member member) {
    _listOfMembers.add(member);
    notifyListeners();
  }

  void currentUser(String currentUserId) {
    //Stream<DocumentSnapshot>  user =  FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots();

    if (_listOfMembers.any((member) => member.id == currentUserId)) {
      // return Member(id: currentUserId, email: , name: name, phoneNumber: phoneNumber)
    }
  }

  final List<String> _namesOfMembers = [];

  List<String> get namesOfMembers {
    return [..._namesOfMembers];
  }

  void addMemberNames(String name) {
    _namesOfMembers.add(name);
    notifyListeners();
  }
}
