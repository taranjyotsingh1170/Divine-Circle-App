import 'package:flutter/material.dart';

import '/models/member.dart';

class Members with ChangeNotifier {
  final List<Member> _listOfMembers = [
    Member(
        id: '1',
        name: 'A',
        phoneNumber: 1,
        isInContentTeam: true,
        isInDesignTeam: false),
    Member(
        id: '2',
        name: 'B',
        phoneNumber: 1,
        isInDesignTeam: true,
        isInContentTeam: false),
    Member(id: '3', name: 'C', phoneNumber: 1, isInKirtanTeam: true),
    Member(
        id: '4',
        name: 'D',
        phoneNumber: 1,
        isInPrTeam: true,
        isInDesignTeam: false),
    Member(
        id: '5',
        name: 'E',
        phoneNumber: 1,
        isInContentTeam: true,
        isInDesignTeam: false),
    Member(
        id: '6',
        name: 'F',
        phoneNumber: 1,
        isInDesignTeam: true,
        isInContentTeam: false),
    Member(id: '7', name: 'G', phoneNumber: 1, isInKirtanTeam: true),
    Member(
        id: '8',
        name: 'H',
        phoneNumber: 1,
        isInContentTeam: true,
        isInDesignTeam: false)
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
}
