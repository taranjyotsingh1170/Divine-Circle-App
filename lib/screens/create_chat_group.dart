import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/search_widget.dart';

class CreateGroupChat extends StatefulWidget {
  const CreateGroupChat({Key? key}) : super(key: key);

  static const routeName = '/create-chat-group';

  @override
  State<CreateGroupChat> createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  List _allUsers = [];
  Future? resultsLoaded;
  List _resultsList = [];
  final _searchController = TextEditingController();
  bool wantToAddInGroup = false;
  List _groupContacts = [];

  getUsersInfo() async {
    var users = await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      _allUsers = users.docs;
    });

    searchResultsList();
    //print(users);
    return 'complete';
  }

  onSearchChanged() {
    searchResultsList();
    //print(_searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != '') {
      // we have search parameter
      for (var user in _allUsers) {
        String userName = user['name'];
        String name = userName.toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(user);
        }
      }
    } else {
      showResults = List.from(_allUsers);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersInfo();
  }

  addContactToGroupList(dynamic userDocument) {
    setState(() {
      _groupContacts.add(userDocument);
      _resultsList.remove(userDocument);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final members = Provider.of<Members>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create chat group',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchWidget(searchController: _searchController),
          Container(
            height: 90,
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: const [
                 CircleAvatar(radius: 30,),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              //itemCount: _allUsers.length - 1,
              itemCount: _resultsList.length,
              itemBuilder: (context, index) {
                if (_allUsers[index]['id'] ==
                    FirebaseAuth.instance.currentUser!.uid) {}
                var userDoc = _resultsList[index];
                return ListTile(
                  //title: Text(_allUsers[index]['name']),
                  title: Text(_resultsList[index]['name']),
                  trailing: const Icon(Icons.circle_outlined),
                  onTap: () {
                    addContactToGroupList(userDoc);
                  },
                );
              },
            ),
          ),
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream:
          //         FirebaseFirestore.instance.collection('users').snapshots(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return const Center(child: Text('Loading...'));
          //       }
          //       return ListView.separated(
          //         separatorBuilder: (ctx, index) => const Divider(),
          //         itemCount: snapshot.data!.docs.length - 1,
          //         itemBuilder: (ctx, index) {
          //           if (snapshot.data!.docs[index]['id'] ==
          //               FirebaseAuth.instance.currentUser!.uid) {
          //             index = index + 1;
          //           }
          //           if (index == snapshot.data!.docs.length - 1) {
          //             getUsersInfo();
          //           }
          //           return ListTile(
          //             title: Text(snapshot.data!.docs[index]['name']),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
