import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../screens/event_detail_screen.dart';

class EventItem extends StatefulWidget {
  const EventItem({Key? key, required this.searchController}) : super(key: key);

  final TextEditingController searchController;

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    Widget singleEvent(snapshot, index) {
      final eventDate = snapshot.data!.docs[index]['event date'];
      final date = eventDate.toDate();

      return InkWell(
        onTap: () {
          // print(DateFormat('hh:mm a').format(DateTime.now()));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailScreen(
                currrentEventId: snapshot.data!.docs[index]['id'],
                // currentEvent: snapshot.data!.docs,
                // currentEvent: _events.eventList[index],
              ),
            ),
          );
        },
        child: Dismissible(
          key: ValueKey(snapshot.data!.docs[index]['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).errorColor,
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.only(bottom: 17),
            decoration: BoxDecoration(
              //border: Border.all(),
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xffBCE1F5), Color(0xffE9F6EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                  child: ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['event title'],
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        letterSpacing: -0.7,
                        color: const Color(0xff333333),
                      ),
                    ),
                    //title: Text(_events.eventList[index].eventName),
                    //subtitle: Text(_events.eventList[index].id),
                    // trailing: Text(
                    //     _events.eventList[index].dateOfEvent),
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: ListTile(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Created by: ',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.9,
                              color: const Color(0xff54545A)),
                        ),
                        Text(
                          snapshot.data!.docs[index]['event added by'],
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: -0.9,
                              color: const Color(0xff54545A)),
                        ),
                      ],
                    ),
                    trailing: Text(
                      DateFormat('dd MMM, yyyy').format(date),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: -0.9,
                          color: const Color(0xff54545A)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(snapshot.data!.docs[index]['event description'],
                      //_events.eventList[index].eventDescription,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          letterSpacing: -0.9,
                          color: const Color(0xff54545A))),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to remove this event?'),
                      actions: [
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ));
          },
          onDismissed: (direction) {
            FirebaseFirestore.instance
                .collection('List of Events')
                .doc(snapshot.data!.docs[index]['id'])
                .delete();
          },
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream:
            // searchController.text.isEmpty
            //     ?
            FirebaseFirestore.instance
                .collection('List of Events')
                .where('event date', isGreaterThanOrEqualTo: DateTime.now())
                .orderBy('event date')
                .snapshots(),
        // : FirebaseFirestore.instance
        //     .collection('List of Events')
        //     .where('case search', arrayContains: searchController.text)
        //     // .where('event added on',
        //     //     isLessThan: _searchController.text)
        //     .orderBy('event date')
        //     .snapshots(),
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
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              //itemCount: _events.eventList.length,
              itemBuilder: (ctx, index) {
                if (widget.searchController.text.isEmpty) {
                  return singleEvent(snapshot, index);
                }
                if (snapshot.data!.docs[index]['event title']
                    .toString()
                    .toLowerCase()
                    .contains(widget.searchController.text.toLowerCase())) {
                  return singleEvent(snapshot, index);
                }
                if (DateFormat('dd MMM, yyyy')
                    .format(snapshot.data!.docs[index]['event date'].toDate())
                    .toString()
                    .toLowerCase()
                    .contains(widget.searchController.text.toLowerCase())) {
                  return singleEvent(snapshot, index);
                }
                return const SizedBox();
              });
        });
  }
}
