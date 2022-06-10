//import 'package:divine_circle/screens/tabs_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//import '../screens/add_event_screen.dart';

import '../widgets/app_drawer.dart';

import '../providers/events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  static const routeName = '/events-screen';

  @override
  Widget build(BuildContext context) {
    final _events = Provider.of<Events>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('EventsScreen',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(AddEventScreen.routeName);
        //     },
        //     icon: const Icon(Icons.add),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events',
              style: GoogleFonts.inter(
                fontSize: 30,
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('List of Events')
                      .orderBy('event date')
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
                                    //currentEvent: snapshot.data.docs![index],
                                    currentEvent: _events.eventList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }
}
