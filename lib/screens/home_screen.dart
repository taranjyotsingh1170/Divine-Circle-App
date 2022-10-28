import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/screens/home_search_screen.dart';

import 'package:divine_circle/screens/one_to_one_chat_members_screen.dart';
import 'package:divine_circle/screens/paths_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';
// import '/screens/members_screen.dart';
import '../screens/to_do_list_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key,
      this.onSeeMoreEventsPressed,
      this.onEventsButtonPressed,
      this.onProfileButtonPressed})
      : super(key: key);

  static const routeName = '/home-screen';

  final Function(int)? onSeeMoreEventsPressed;
  final Function(int)? onEventsButtonPressed;
  final Function(int)? onProfileButtonPressed;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool homeToEventScreen = false;
  bool homeToProfileScreen = false;
  String username = '';
  bool wannaSearch = false;
  final _searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  String name() {
    // ignore: unused_local_variable
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        username = fields!['name'];
      });
    });
    return username;
  }

  // AppBar searchActivated() {
  //   return AppBar(
  //     leadingWidth: 43,
  //     title: Container(
  //       height: 40,
  //       margin: const EdgeInsets.only(top: 5),
  //       padding: const EdgeInsets.symmetric(horizontal: 10),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: const Color(0xffC3DCEB)),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Expanded(
  //             child: TextField(
  //               focusNode: searchFocus,
  //               controller: _searchController,
  //               decoration: const InputDecoration(
  //                 hintText: 'Search events',
  //                 hintStyle: TextStyle(color: Color(0xff6B737C)),
  //                 border: InputBorder.none,
  //               ),
  //               textCapitalization: TextCapitalization.sentences,
  //               autofocus: true,
  //               onChanged: (value) {
  //                 onSearchChanged();
  //               },
  //               onTap: () {
  //                 setState(() {
  //                   wannaSearch = true;
  //                 });
  //               },
  //             ),
  //           ),
  //           IconButton(
  //             padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
  //             icon: !wannaSearch
  //                 ? const Icon(Icons.search, color: Color(0xff54545A))
  //                 : const Icon(Icons.close, color: Color(0xff54545A)),
  //             onPressed: () {
  //               setState(() {
  //                 wannaSearch = !wannaSearch;
  //               });
  //               if (!wannaSearch) {
  //                 _searchController.clear();
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       Padding(
  //         padding: const EdgeInsets.only(right: 15),
  //         child: GestureDetector(
  //           child: Image.asset('assets/images/chat_icon.png',
  //               height: 22, width: 22),
  //           onTap: () => Navigator.of(context).push(MaterialPageRoute(
  //               builder: (_) => const OneToOneChatMembersScreen())),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget homeShortcut(Size deviceSize, String shortcutName, String imagename,
      void Function() function) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 60,
        width: deviceSize.width * 0.4,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset('assets/images/$imagename', height: 32, width: 32),
            const SizedBox(width: 12),
            Text(
              shortcutName,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff57575D),
                  fontSize: 16,
                  letterSpacing: -0.5),
            ),
          ],
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xffF1F1F1),
            border: Border.all(color: const Color(0xffD9D9D9))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if (wannaSearch) {
      searchFocus.requestFocus();
    } else {
      searchFocus.unfocus();
    }

    return WillPopScope(
      onWillPop: () async {
        if (wannaSearch == true && _searchController.text.isEmpty) {
          setState(() {
            wannaSearch = false;
          });
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            wannaSearch = false;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 43,
            // title: Container(
            //   height: 40,
            //   margin: const EdgeInsets.only(top: 5),
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: const Color(0xffC3DCEB)),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           focusNode: searchFocus,
            //           controller: _searchController,
            //           decoration: const InputDecoration(
            //             hintText: 'Search for events, members etc',
            //             hintStyle:
            //                 TextStyle(color: Color(0xff6B737C), fontSize: 14),
            //             border: InputBorder.none,
            //           ),
            //           textCapitalization: TextCapitalization.sentences,
            //           onChanged: (value) {
            //             onSearchChanged();
            //           },
            //           onTap: () {
            //             setState(() {
            //               wannaSearch = true;
            //             });
            //           },
            //         ),
            //       ),
            //       IconButton(
            //         padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
            //         icon: !wannaSearch
            //             ? const Icon(Icons.search, color: Color(0xff54545A))
            //             : const Icon(Icons.close, color: Color(0xff54545A)),
            //         onPressed: () {
            //           setState(() {
            //             wannaSearch = !wannaSearch;
            //           });
            //           if (!wannaSearch) {
            //             _searchController.clear();
            //           }
            //         },
            //       )
            //     ],
            //   ),
            // ),
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
                  // const Text(
                  //   'Search for events, members etc',
                  //   style: TextStyle(
                  //       color: Color(0xff6B737C),
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  Expanded(
                    child: TextField(
                      focusNode: searchFocus,
                      controller: _searchController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Search events, members etc',
                        hintStyle:
                            TextStyle(color: Color(0xff6B737C), fontSize: 14),
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        onSearchChanged();
                      },
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HomeSearchScreen.routeName);
                        // showSearch(
                        //     context: context, delegate: MySearchDelegate());
                        // null;
                        // setState(() {
                        //   wannaSearch = true;
                        // });
                      },
                    ),
                  ),

                  IconButton(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
                    icon: const Icon(Icons.search, color: Color(0xff54545A)),
                    onPressed: () {
                      Navigator.of(context)
                            .pushNamed(HomeSearchScreen.routeName);
                      // showSearch(
                      //     context: context, delegate: MySearchDelegate());
                    },
                  )
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  child: Image.asset('assets/images/chat_icon.png',
                      height: 22, width: 22),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const OneToOneChatMembersScreen())),
                ),
              )
            ],
          ),

          // !wannaSearch
          //     ? AppBar(
          //         leadingWidth: 43,
          //         backgroundColor: const Color(0xffB9E0F7),
          //         elevation: 0,
          //         actions: [
          //           // PopupMenuButton(
          //           //   offset: const Offset(1, 45),
          //           //   shape: const RoundedRectangleBorder(
          //           //       borderRadius: BorderRadius.all(Radius.circular(10))),
          //           //   itemBuilder: (context) => [
          //           //     PopupMenuItem(
          //           //       child: const Text('Members'),
          //           //       value: 1,
          //           //       onTap: () {
          //           //         //Navigator.of(context).pushNamed(MembersScreen.routeName);
          //           //       },
          //           //     ),
          //           //     // const PopupMenuItem(
          //           //     //   child: Text('Content Team'),
          //           //     //   value: 2,
          //           //     // ),
          //           //     // const PopupMenuItem(
          //           //     //   child: Text('Design Team'),
          //           //     //   value: 3,
          //           //     // ),
          //           //   ],
          //           //   onSelected: (value) {
          //           //     if (value == 1) {
          //           //       Navigator.of(context).pushNamed(MembersScreen.routeName);
          //           //     }
          //           //   },
          //           // ),
          //           IconButton(
          //             icon: const Icon(Icons.search),
          //             onPressed: () {
          //               setState(() {
          //                 wannaSearch = !wannaSearch;
          //               });
          //             },
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 15, left: 10),
          //             child: GestureDetector(
          //               child: Image.asset(
          //                 'assets/images/chat_icon.png',
          //                 height: 22,
          //                 width: 22,
          //               ),
          //               onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (_) => const OneToOneChatMembersScreen())),
          //             ),
          //           ),
          //         ],
          //       )
          //     : searchActivated(),
          drawer: const AppDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 15,
                decoration: const BoxDecoration(
                  color: Color(0xffB9E0F7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView(
                    children: [
                      Text(
                        'Welcome to Divine Circle',
                        style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                            color: const Color(0xff333333)),
                      ),
                      Text(
                        name(),
                        style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: -1,
                            color: Color(0xff333333)),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            homeShortcut(deviceSize, 'Chat', 'Chat.png', () {
                              Navigator.of(context).pushNamed(
                                  OneToOneChatMembersScreen.routeName);
                            }),
                            homeShortcut(
                              deviceSize,
                              'Profile',
                              'Profile.png',
                              () {
                                setState(() {
                                  homeToProfileScreen = true;
                                });

                                if (homeToProfileScreen) {
                                  widget.onProfileButtonPressed!(
                                      4); // call back function to change the index of the selected page to EventsScreen in Bottom Navigation bar
                                }

                                setState(() {
                                  homeToProfileScreen = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            homeShortcut(
                              deviceSize,
                              'Paths',
                              'Paths.png',
                              () {
                                Navigator.of(context)
                                    .pushNamed(PathsScreen.routeName);
                              },
                            ),
                            homeShortcut(
                              deviceSize,
                              'Events',
                              'Events.png',
                              () {
                                setState(() {
                                  homeToEventScreen = true;
                                });

                                if (homeToEventScreen) {
                                  widget.onEventsButtonPressed!(
                                      1); // call back function to change the index of the selected page to EventsScreen in Bottom Navigation bar
                                }

                                setState(() {
                                  homeToEventScreen = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recently added events',
                            style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1),
                          ),
                          TextButton(
                            child: Text(
                              'see more',
                              style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -1),
                            ),
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
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('List of Events')
                                .where('event date',
                                    isGreaterThanOrEqualTo: DateTime.now())
                                .orderBy('event date', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              }
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ListView.separated(
                                  //shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 20),
                                  itemCount: snapshot.data!.docs.length < 4
                                      ? snapshot.data!.docs.length
                                      : 4,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 170,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xffF1F1F1)),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['event title'],
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -1,
                                              color: const Color(0xff57575D)),
                                        ),
                                      ],
                                    );
                                  },
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
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 8, right: 10, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffD9D9D9)),
                          borderRadius: BorderRadius.circular(18),

                          // gradient: const LinearGradient(
                          //   colors: [Color(0xffBCE1F5), Color(0xffE9F6EE)],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   stops: [0, 1],
                          // ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'To Do List',
                                style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: deviceSize.width * 0.55,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Tasks')
                                        .orderBy('task added on',
                                            descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: Text(''),
                                        );
                                      }
                                      if (snapshot.data!.docs.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Text(
                                              '${index + 1}. ${snapshot.data!.docs[index]['task']}',
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.9,
                                                color: const Color(0xff54545A),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(ToDoListScreen.routeName);
                                  },
                                  child: Row(
                                    children: [
                                      Text('Show All',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -1,
                                              color: Colors.white)),
                                      const SizedBox(width: 10),
                                      Image.asset(
                                        'assets/images/Todo_more.png',
                                        height: 13,
                                        width: 13,
                                      )
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                    backgroundColor: const Color(0xff3F5C8C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  // @override
  // ThemeData appBarTheme(BuildContext context) {

  //   final ThemeData theme = Theme.of(context);
  //   return theme.copyWith(
  //     primaryColor: Colors.white,
  //     primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),

  //     textTheme: theme.textTheme.copyWith(
  //       headline1: const TextStyle(fontWeight: FontWeight.normal),
  //     ),
  //   );
  //   // return super.appBarTheme(context);
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(''),
                  );
                }
                if (query.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                if (snapshot.data!.docs[index]['name']
                    .toString()
                    .toLowerCase()
                    .contains(query)) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                return const SizedBox();
              });
        });
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
    //throw UnimplementedError();
  }
}
