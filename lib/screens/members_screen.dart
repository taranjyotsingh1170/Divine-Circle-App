import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/models/member.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Member> members = [];

  @override
  Widget build(BuildContext context) {
    final _membersData = Provider.of<Members>(context);

    if (_showContentTeamMembers) {
      setState(() {
        members = _membersData.contentTeamMembers;
      });
    } else if (_showDesignTeamMembers) {
      setState(() {
        members = _membersData.designTeamMembers;
      });
    } else if (_showAllMembers) {
      setState(() {
        members = _membersData.memberList;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Members',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.black)),
        iconTheme: Theme.of(context).iconTheme,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Loading...'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length ,
              itemBuilder: (ctx, index) {
                bool isInDesignTeam =
                    snapshot.data!.docs[index]['isInDesignTeam'];
                bool isInContentTeam =
                    snapshot.data!.docs[index]['isInContentTeam'];
                bool isInPrTeam = snapshot.data!.docs[index]['isInPrTeam'];
                bool isInKirtanTeam =
                    snapshot.data!.docs[index]['isInKirtanTeam'];
                
                
                if (snapshot.data!.docs[index]['id'] ==
                    FirebaseAuth.instance.currentUser!.uid) {
                      return const SizedBox(height: 0,width: 0);
                  //index = index + 1;
                }

                return ListTile(
                  title: Text(snapshot.data!.docs[index]['name']),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextButton(
                            child: !snapshot.data!.docs[index]
                                    ['isInContentTeam']
                                ? const Text('Add to Content Team')
                                : const Text('Remove from Content Team'),
                            onPressed: () {
                              isInContentTeam = !isInContentTeam;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isInContentTeam': isInContentTeam,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(),
                          TextButton(
                            child: !snapshot.data!.docs[index]['isInDesignTeam']
                                ? const Text('Add to Design Team')
                                : const Text('Remove from Design Team'),
                            onPressed: () {
                              isInDesignTeam = !isInDesignTeam;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isInDesignTeam': isInDesignTeam,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(),
                          TextButton(
                            child: !snapshot.data!.docs[index]['isInPrTeam']
                                ? const Text('Add to PR Team')
                                : const Text('Remove from PR Team'),
                            onPressed: () {
                              isInPrTeam = !isInPrTeam;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isInPrTeam': isInPrTeam,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(),
                          TextButton(
                            child: !snapshot.data!.docs[index]['isInKirtanTeam']
                                ? const Text('Add to Kirtan Team')
                                : const Text('Remove from Kirtan Team'),
                            onPressed: () {
                              isInKirtanTeam = !isInKirtanTeam;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isInKirtanTeam': isInKirtanTeam,
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
