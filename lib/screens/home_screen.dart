import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/screens/one_to_one_chat_members_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:divine_circle/screens/one_to_one_chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '/screens/members_screen.dart';
import '../screens/to_do_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        // title: Text('HomeScreen',
        //     style: GoogleFonts.inter(
        //         fontWeight: FontWeight.w500, color: Colors.white)),
        //iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        actions: [
          PopupMenuButton(
            offset: const Offset(1, 45),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Members'),
                value: 1,
                onTap: () {
                  //Navigator.of(context).pushNamed(MembersScreen.routeName);
                },
              ),
              // const PopupMenuItem(
              //   child: Text('Content Team'),
              //   value: 2,
              // ),
              // const PopupMenuItem(
              //   child: Text('Design Team'),
              //   value: 3,
              // ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.of(context).pushNamed(MembersScreen.routeName);
              }
            },
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const OneToOneChatMembersScreen())),
              icon: const Icon(Icons.chat_bubble_outline_rounded)),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to Divine Circle',
                    style: GoogleFonts.inter(
                        fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text('');
                            }
                            return Text(
                              snapshot.data!['name'],
                              style: const TextStyle(fontSize: 20),
                            );
                          }),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.expand_more,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ToDoListScreen.routeName);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(25)),
              child: const ListTile(
                title: Text('To Do List'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
