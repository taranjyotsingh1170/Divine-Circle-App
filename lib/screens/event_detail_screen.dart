import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
//import 'package:provider/provider.dart';

//import '/providers/events.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    Key? key,
    this.currentEvent,
    required this.currrentEventId,
  }) : super(key: key);

  static const routeName = '/event-detail-screen';

  final Event? currentEvent;

  final String currrentEventId;

  Widget myTasks() {
    return Row(
      children: [
        Container(
          height: 40,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffebedec),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffebedec),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //final _event = Provider.of<Events>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        //title: Text(currentEvent.eventName),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('List of Events')
                  .doc(currrentEventId)
                  .delete();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),

          //const Padding(padding:  EdgeInsets.only(right: 20))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xffBCE1F5), Color(0xffDDE6E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('List of Events')
                    .doc(currrentEventId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('');
                  }
                  List eventCoordinators =
                      List.from(snapshot.data!['event coordinators']);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!['event title'],
                          //currentEvent.eventName,
                          style: GoogleFonts.inter(fontSize: 40),
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          Text('Created by : ',
                              style: GoogleFonts.inter(fontSize: 18)),
                          Text(
                            snapshot.data!['event added by'],
                            //currentEvent.dateOfEvent,
                            style: GoogleFonts.inter(fontSize: 18),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          Text('Date : ',
                              style: GoogleFonts.inter(fontSize: 18)),
                          Text(
                            DateFormat('dd MMM, yyyy')
                                .format(snapshot.data!['event date'].toDate()),
                            //currentEvent.dateOfEvent,
                            style: GoogleFonts.inter(fontSize: 18),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Time : ',
                                style: GoogleFonts.inter(fontSize: 18)),
                            Text(
                              // DateFormat('hh:mm a').format(dateTime)
                              snapshot.data!['event time'],
                              //currentEvent.dateOfEvent,
                              style: GoogleFonts.inter(fontSize: 18),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: deviceSize.width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xffd9d9d9)),
                                  ),
                                  // const Text('Inbox')
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: deviceSize.width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xffd9d9d9)),
                                  ),
                                  // const Text('Profile')
                                ],
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 20),
                        Text(
                          'Event Description :',
                          style: GoogleFonts.inter(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!['event description'],
                          //currentEvent.eventDescription,
                          softWrap: true,
                          maxLines: 8,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Text('Event Managers :',
                            style: GoogleFonts.inter(fontSize: 18)),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                    child: Icon(Icons.account_circle_outlined)),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text('Simran',
                                    style: GoogleFonts.inter(fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                    child: Icon(Icons.account_circle_outlined)),
                                const SizedBox(width: 15),
                                Text('Taran',
                                    style: GoogleFonts.inter(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Event Coordinators :',
                            style: GoogleFonts.inter(fontSize: 18)),
                        const SizedBox(height: 10),
                        ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          shrinkWrap: true,
                          itemCount: eventCoordinators.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                const CircleAvatar(
                                    child: Icon(Icons.account_circle_outlined)),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  eventCoordinators[index],
                                  style: GoogleFonts.inter(fontSize: 18),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text('My Tasks : ',
                                    style: GoogleFonts.inter(fontSize: 18)),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text('Public comments : ',
                                    style: GoogleFonts.inter(fontSize: 18)),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                                myTasks(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
