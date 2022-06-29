//import 'package:divine_circle/screens/tabs_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';

//import '../screens/add_event_screen.dart';

import '../widgets/app_drawer.dart';

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
  List _allEvents = [];
  List _resultsList = [];
  Future? resultsLoaded;

  getEventsInfo() async {
    var events = await FirebaseFirestore.instance
        .collection('List of Events')
        .orderBy('event added on')
        .get();

    setState(() {
      _allEvents = events.docs;
    });

    searchResultsList();

    return 'Complete';
  }

  onSearchChanged() {
    searchResultsList();
    //print(_searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != '') {
      // we have search parameter
      for (var event in _allEvents) {
        String eventName = event['event title'];
        String name = eventName.toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(event);
        }
      }
    } else {
      showResults = List.from(_allEvents);
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
    resultsLoaded = getEventsInfo();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        appBar: AppBar(
          title: !wannaSearch
              ? Text('EventsScreen',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500, color: Colors.white))
              : TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                ),
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          actions: [
            IconButton(
              icon: !wannaSearch
                  ? const Icon(Icons.search)
                  : const Icon(Icons.close),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events',
                style: GoogleFonts.inter(fontSize: 30),
              ),
              Expanded(
                child: 
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

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('List of Events')
                        .orderBy('event added on')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(''),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No event added yet!'),
                        );
                      }
                      return ListView.separated(
                          separatorBuilder: (ctx, index) => const Divider(),
                          itemCount: snapshot.data!.docs.length,
                          //itemCount: _events.eventList.length,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailScreen(
                                      currrentEventId:
                                          snapshot.data!.docs[index]['id'],
                                      // currentEvent: snapshot.data!.docs,
                                      // currentEvent: _events.eventList[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(snapshot.data!.docs[index]
                                          ['event title']),
                                      trailing: Text(snapshot.data!.docs[index]
                                          ['event date']),
                                      //title: Text(_events.eventList[index].eventName),
                                      //subtitle: Text(_events.eventList[index].id),
                                      // trailing: Text(
                                      //     _events.eventList[index].dateOfEvent),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            ['event description'],
                                        //_events.eventList[index].eventDescription,
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        // bottomNavigationBar: const TabsScreen(),
      ),
    );
  }
}
