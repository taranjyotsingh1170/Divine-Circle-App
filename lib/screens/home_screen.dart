import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:divine_circle/screens/one_to_one_chat_members_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '/screens/members_screen.dart';
import '../screens/to_do_list_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.onSeeMoreEventsPressed}) : super(key: key);

  static const routeName = '/home-screen';

  final Function(int)? onSeeMoreEventsPressed;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool homeToEventScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffB9E0F7),
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
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                color: Color(0xffB9E0F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              height: 170,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently added events',
                    style: GoogleFonts.inter(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: const Text('see more'),
                    onPressed: () {
                      setState(() {
                        homeToEventScreen = true;
                      });

                      if (homeToEventScreen) {
                        widget.onSeeMoreEventsPressed!(
                            1); // call back function to change the index of the selected page to EventsScreen in Bottom Navigation bar
                      }

                      setState(() {
                        homeToEventScreen = false;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              //padding: const EdgeInsets.only(left: 20),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              //decoration: BoxDecoration(border: Border.all()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('List of Events')
                          .orderBy('event added on', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        return Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              //shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 20),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 170,
                                      width: 150,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['event title'],
                                      style: GoogleFonts.inter(fontSize: 15),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).pushNamed(EventsScreen.routeName);
                  //   },
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       const CircleAvatar(
                  //         radius: 30,
                  //         backgroundColor: Colors.grey,
                  //         child: Icon(
                  //           Icons.arrow_right_alt_sharp,
                  //           size: 45,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       Text('more', style: GoogleFonts.inter(fontSize: 15))
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ToDoListScreen.routeName);
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      ),
    );
  }
}
