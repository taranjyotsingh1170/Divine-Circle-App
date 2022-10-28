import 'package:divine_circle/widgets/event_item.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';

//import '../screens/add_event_screen.dart';

import '../widgets/app_drawer.dart';
import 'one_to_one_chat_members_screen.dart';

//import '../providers/events.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  static const routeName = '/events-screen';

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(
                        hintText: 'Search events',
                        hintStyle:
                            TextStyle(color: Color(0xff6B737C), fontSize: 14),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        onSearchChanged();
                      },
                      onTap: () {
                        setState(() {
                          wannaSearch = true;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
                    icon: !wannaSearch
                        ? const Icon(Icons.search, color: Color(0xff54545A))
                        : const Icon(Icons.close, color: Color(0xff54545A)),
                    onPressed: () {
                      setState(() {
                        wannaSearch = !wannaSearch;
                      });

                      if (!wannaSearch) {
                        _searchController.clear();
                      }
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events',
                        style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                            color: const Color(0xff333333)),
                      ),
                      Expanded(
                        child: EventItem(searchController: _searchController),
                        // ListView.separated(
                        //     separatorBuilder: (ctx, index) => const Divider(),
                        //     itemCount: _resultsList.length,
                        //     //itemCount: _events.eventList.length,
                        //     itemBuilder: (ctx, index) {
                        //       return InkWell(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //               builder: (_) => EventDetailScreen(
                        //                 currrentEventId: _resultsList[index]['id'],
                        //                 // currentEvent: snapshot.data!.docs,
                        //                 // currentEvent: _events.eventList[index],
                        //               ),
                        //             ),
                        //           );
                        //           print(_resultsList[index]['event title']);
                        //           _searchController.clear();
                        //           wannaSearch = false;
                        //         },
                        //         child: Container(
                        //           margin: const EdgeInsets.symmetric(vertical: 10),
                        //           padding: const EdgeInsets.only(bottom: 15),
                        //           decoration: BoxDecoration(
                        //               border: Border.all(),
                        //               borderRadius: BorderRadius.circular(25)),
                        //           child: Column(
                        //             children: [
                        //               ListTile(
                        //                 title: Text(_resultsList[index]['event title']),
                        //                 trailing:
                        //                     Text(_resultsList[index]['event date']),
                        //                 //title: Text(_events.eventList[index].eventName),
                        //                 //subtitle: Text(_events.eventList[index].id),
                        //                 // trailing: Text(
                        //                 //     _events.eventList[index].dateOfEvent),
                        //               ),
                        //               Container(
                        //                 alignment: Alignment.centerLeft,
                        //                 padding:
                        //                     const EdgeInsets.symmetric(horizontal: 15),
                        //                 child: Text(
                        //                   _resultsList[index]['event description'],
                        //                   //_events.eventList[index].eventDescription,
                        //                   softWrap: true,
                        //                   maxLines: 3,
                        //                   overflow: TextOverflow.ellipsis,
                        //                   style: const TextStyle(fontSize: 18),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: const AppDrawer(),
        ),
      ),
    );
  }
}
