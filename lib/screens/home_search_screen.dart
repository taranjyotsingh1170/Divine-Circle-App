import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SearchOptions {
  members,
  events,
}

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  static const routeName = '/home-search-screen';

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreen();
}

class _HomeSearchScreen extends State<HomeSearchScreen> {
  final _searchController = TextEditingController();
  bool wannaSearch = false;
  FocusNode searchFocus = FocusNode();
  Stream<QuerySnapshot<Map<String, dynamic>>> streamSnapshot =
      FirebaseFirestore.instance.collection('users').snapshots();

  bool showEvents = false;

  onSearchChanged() {
    setState(() {});
  }

  Widget _showMembers() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nothing to show yet!'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (_searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                if (snapshot.data!.docs[index]['name']
                    .toString()
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                return const SizedBox();
              });
        });
  }

  Widget _showEvents() {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('List of Events').orderBy('event date').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nothing to show yet!'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (_searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['event title']),
                  );
                }

                if (snapshot.data!.docs[index]['event title']
                    .toString()
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['event title']),
                  );
                }

                return const SizedBox();
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          wannaSearch = false;
        });
      },
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 43,
            title: Container(
              height: 40,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffC3DCEB)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: searchFocus,
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search events, members etc',
                        hintStyle:
                            TextStyle(color: Color(0xff6B737C), fontSize: 14),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        onSearchChanged();
                      },
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
                    icon: const Icon(Icons.close, color: Color(0xff54545A)),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                ],
              ),
            ),
            actions: [
              PopupMenuButton(
                icon: const Icon(Icons.filter_3),
                offset: const Offset(1, 45),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text('Members'),
                    value: SearchOptions.members,
                  ),
                  const PopupMenuItem(
                    child: Text('Events'),
                    value: SearchOptions.events,
                  ),
                ],
                onSelected: (value) {
                  if (value == SearchOptions.members) {
                    setState(() {
                      showEvents = false;
                    });
                  } else if (value == SearchOptions.events) {
                    setState(() {
                      showEvents = true;
                    });
                  }
                },
              )
            ],
          ),
          body: !showEvents ? _showMembers() : _showEvents()),
    );
  }
}
