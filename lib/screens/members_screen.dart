import 'package:divine_circle/models/member.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/members.dart';

enum TeamMemberOptions {
  allMembers,
  contentTeam,
  designTeam,
}

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  static const routeName = '/members-screen';

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  bool _showAllMembers = true;
  bool _showContentTeamMembers = false;
  bool _showDesignTeamMembers = false;
  List<Member> _members = [];
  
  @override
  Widget build(BuildContext context) {
    final _membersData = Provider.of<Members>(context);

    if (_showContentTeamMembers) {
      setState(() {
        _members = _membersData.contentTeamMembers;
      });
    } else if (_showDesignTeamMembers) {
      setState(() {
        _members = _membersData.designTeamMembers;
      });
    } else if (_showAllMembers) {
      setState(() {
        _members = _membersData.memberList;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          PopupMenuButton(
            offset: const Offset(1, 45),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('All Members'),
                value: TeamMemberOptions.allMembers,
                onTap: () {
                  //Navigator.of(context).pushNamed(MembersScreen.routeName);
                },
              ),
              const PopupMenuItem(
                child: Text('Content Team'),
                value: TeamMemberOptions.contentTeam,
              ),
              const PopupMenuItem(
                child: Text('Design Team'),
                value: TeamMemberOptions.designTeam,
              ),
            ],
            onSelected: (value) {
              if (value == TeamMemberOptions.allMembers) {
                setState(() {
                  _showAllMembers = true;
                  _showContentTeamMembers = false;
                  _showDesignTeamMembers = false;
                });
                //Navigator.of(context).pushNamed(MembersScreen.routeName);
              }

              if (value == TeamMemberOptions.contentTeam) {
                setState(() {
                  _showAllMembers = false;
                  _showContentTeamMembers = true;
                  _showDesignTeamMembers = false;
                });
              }

              if (value == TeamMemberOptions.designTeam) {
                setState(() {
                  _showAllMembers = false;
                  _showContentTeamMembers = false;
                  _showDesignTeamMembers = true;
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_members[index].name),
        ),
      ),
    );
  }
}
