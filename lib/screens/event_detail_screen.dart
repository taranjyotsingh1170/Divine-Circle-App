import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/event.dart';
//import 'package:provider/provider.dart';

//import '/providers/events.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen(
      {Key? key, this.currentEvent, required this.currrentEventId})
      : super(key: key);

  static const routeName = '/event-detail-screen';

  final Event? currentEvent;

  final String currrentEventId;

  @override
  Widget build(BuildContext context) {
    //final _event = Provider.of<Events>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('List of Events')
                .doc(currrentEventId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!['event title'],
                    //currentEvent.eventName,
                    style: GoogleFonts.inter(fontSize: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot.data!['event date'],
                    //currentEvent.dateOfEvent,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Event Managers :',
                    style: GoogleFonts.inter(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const CircleAvatar(
                              child: Icon(Icons.account_circle_outlined)),
                          const SizedBox(width: 15),
                          Text('Taran', style: GoogleFonts.inter(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Event Coordinators :',
                    style: GoogleFonts.inter(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                              child: Icon(Icons.account_circle_outlined)),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Saheb',
                            style: GoogleFonts.inter(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const CircleAvatar(
                              child: Icon(Icons.account_circle_outlined)),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Pratyush',
                            style: GoogleFonts.inter(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                    //overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
