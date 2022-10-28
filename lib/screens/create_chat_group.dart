import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/search_widget.dart';
import 'group_details_screen.dart';

class CreateGroupChat extends StatefulWidget {
  const CreateGroupChat({Key? key}) : super(key: key);

  static const routeName = '/create-chat-group';

  @override
  State<CreateGroupChat> createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  final _searchController = TextEditingController();

  List groupMembersIDList = [];
  List groupMembersNameList = [];

  addMembersToList(snapshot, index) {
    setState(() {
      groupMembersIDList.add(snapshot.data!.docs[index]['id']);
      groupMembersNameList.add(snapshot.data!.docs[index]['name']);
    });
  }

  removeMembersFromList(snapshot, index) {
    setState(() {
      groupMembersIDList.remove(snapshot.data!.docs[index]['id']);
      groupMembersNameList.remove(snapshot.data!.docs[index]['name']);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final members = Provider.of<Members>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        FirebaseFirestore.instance.collection('users').get().then((value) {
          for (DocumentSnapshot docs in value.docs) {
            docs.reference.update({'isSelectedForGroupChat': false});
          }
        });
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create chat group',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500, color: Colors.black)),
            iconTheme: Theme.of(context).iconTheme,
            actions: [
              groupMembersNameList.isNotEmpty
                  ? TextButton(
                      child: const Text('next'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>  GroupDetailsScreen(groupMembersNameList: groupMembersNameList,)));
                      },
                    )
                  : const SizedBox(),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchWidget(
                  searchController: _searchController,
                  onSearchChanged: () => setState(() {})),
              if (groupMembersNameList.isNotEmpty)
                Container(
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: groupMembersNameList.length,
                      itemBuilder: (context, index) {
                        return Row(children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Text(
                                  groupMembersNameList[index],
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff54545A),
                                      fontSize: 12,
                                      letterSpacing: -0.5),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(groupMembersIDList[index])
                                        .update(
                                            {'isSelectedForGroupChat': false});

                                    groupMembersIDList
                                        .remove(groupMembersIDList[index]);
                                    groupMembersNameList
                                        .remove(groupMembersNameList[index]);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10)
                        ]);
                      }),
                ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading...'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length - 1,
                      itemBuilder: (ctx, index) {
                        if (snapshot.data!.docs[index]['id'] ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          index = index + 1;
                        }
                        bool isSelectedForGroupChat = snapshot.data!.docs[index]
                            ['isSelectedForGroupChat'];

                        if (_searchController.text.isEmpty) {
                          return ListTile(
                            title: Text(snapshot.data!.docs[index]['name']),
                            trailing: isSelectedForGroupChat
                                ? IconButton(
                                    icon:
                                        const Icon(Icons.check_circle_rounded),
                                    onPressed: () {},
                                  )
                                : null,
                            onTap: () {
                              isSelectedForGroupChat = !isSelectedForGroupChat;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isSelectedForGroupChat': isSelectedForGroupChat
                              });

                              if (isSelectedForGroupChat) {
                                addMembersToList(snapshot, index);
                              } else {
                                removeMembersFromList(snapshot, index);
                              }
                            },
                          );
                        }

                        if (snapshot.data!.docs[index]['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())) {
                          return ListTile(
                            title: Text(snapshot.data!.docs[index]['name']),
                            trailing: isSelectedForGroupChat
                                ? const Icon(Icons.check_circle_rounded)
                                : null,
                            onTap: () {
                              isSelectedForGroupChat = !isSelectedForGroupChat;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data!.docs[index]['id'])
                                  .update({
                                'isSelectedForGroupChat': isSelectedForGroupChat
                              });

                              if (isSelectedForGroupChat) {
                                addMembersToList(snapshot, index);
                              } else {
                                removeMembersFromList(snapshot, index);
                              }
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
