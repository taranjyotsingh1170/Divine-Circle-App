import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';
import '../widgets/app_drawer.dart';
import 'add_event_screen.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);
  static const routeName = '/event-calendar';

  //final DateTime pickedDay;

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedDayString = '';
  //final DateTime _currentDay = DateTime.now();

  //final Map<DateTime, List<Event>> _mySelectedEvents = {};

  final TextEditingController _eventController = TextEditingController();

  // @override
  // void initState() {
  //   _mySelectedEvents = {};
  //   super.initState();
  // }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Events>(context);

    List<Event> _getEventsFromDay(DateTime date) {
      //return _mySelectedEvents[date] ?? [];
      return event.mySelectedEvents[date] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 43,
        title: Text(
          'Event Calendar',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(1947),
            lastDay: DateTime(2050),
            calendarFormat: _format,
            onFormatChanged: (CalendarFormat format) {
              setState(() {
                _format = format;
              });
            },
            eventLoader: _getEventsFromDay,

            // Day Changed
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
                _selectedDayString =
                    DateFormat('dd MMM, yyyy').format(_selectedDay);
                //print(_selectedDayString);

                //print(_selectedDay);
                // print(_focusedDay);
                // print(_currentDay);
              });

              //print(_focusedDay);
            },
            selectedDayPredicate: (date) {
              return isSameDay(_selectedDay, date);
            },

            // To style the calendar
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // border: const Border.symmetric(
                //   vertical: BorderSide(width: 10)
                //   horizontal:
                //),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.black),
              selectedDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Events',
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('List of Events')
                    .orderBy('event date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('');
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No event added yet!'),
                    );
                  }

                  
                  return ListView.builder(
                    // separatorBuilder: (ctx, index) => snapshot.data!.docs[index]
                    //             ['event date'].toDate() !=
                    //         _selectedDayString
                    //     ? const SizedBox()
                    //     : const Divider(),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      final eventDate =
                          snapshot.data!.docs[index]['event date'];
                      final date = eventDate.toDate();

                      // if (date != _selectedDayString) {
                      //   return const SizedBox();
                      // }

                      return Dismissible(
                        key: ValueKey(snapshot.data!.docs[index]['id']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Theme.of(context).errorColor,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        child: ListTile(
                          title:
                              Text(snapshot.data!.docs[index]['event title']),
                          trailing:
                              Text(DateFormat('dd MMM, yyyy').format(date)),
                        ),
                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: const Text(
                                        'Do you want to remove this event?'),
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
                          // setState(() {
                          //   event.deleteEvent(
                          //       snapshot.data!.docs[index]['id'],
                          //       _selectedDay);
                          // });
                          //( '${currentEvent.eventName} deleted');
                        },
                      );
                    },
                  );
                }),

            // ..._getEventsFromDay(_selectedDay).map(
            //   (Event currentEvent) => Dismissible(
            //     key: ValueKey(currentEvent.id),
            //     direction: DismissDirection.endToStart,
            //     background: Container(
            //       alignment: Alignment.centerRight,
            //       color: Theme.of(context).errorColor,
            //       padding: const EdgeInsets.only(right: 20),
            //       margin: const EdgeInsets.symmetric(
            //           horizontal: 15, vertical: 4),
            //       child: const Icon(
            //         Icons.delete,
            //         color: Colors.white,
            //         size: 30,
            //       ),
            //     ),
            //     child: ListTile(
            //       title: Text(currentEvent.eventName),
            //       trailing: Text(currentEvent.dateOfEvent),
            //     ),
            //     confirmDismiss: (direction) {
            //       return showDialog(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //                 title: const Text('Are you sure?'),
            //                 content: const Text(
            //                     'Do you want to remove this event?'),
            //                 actions: [
            //                   TextButton(
            //                     child: const Text('Yes'),
            //                     onPressed: () {
            //                       Navigator.of(ctx).pop(true);
            //                     },
            //                   ),
            //                   TextButton(
            //                     child: const Text('No'),
            //                     onPressed: () {
            //                       Navigator.of(ctx).pop();
            //                     },
            //                   ),
            //                 ],
            //               ));
            //     },
            //     onDismissed: (direction) {
            //       //FirebaseFirestore.instance.collection('List of Events').doc()
            //       // StreamBuilder<QuerySnapshot>(
            //       //   stream: FirebaseFirestore.instance.collection('List of Events').snapshots(),
            //       //   builder: (context, snapshot) {
            //       //     snapshot.data!.docs[]
            //       //   },
            //       // );
            //       setState(() {
            //         event.deleteEvent(currentEvent.id, _selectedDay);
            //       });
            //       //( '${currentEvent.eventName} deleted');
            //     },
            //   ),
            //   // child: ListTile(
            //   //   title: Text(currentEvent.eventName),
            //   //   trailing: Text(currentEvent.dateOfEvent),
            //   // ),
            // ),
            //const Divider(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEventScreen(
              selectedDateString: _selectedDayString,
              selectedDate: _selectedDay,
            ),
          ),
        ),
//         onPressed: () => showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('New Event'),
//             content: TextFormField(
//               controller: _eventController,
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('Cancel'),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               TextButton(
//                 child: const Text('Ok'),
//                 onPressed: () {
//                   if (_eventController.text.isEmpty) {
//                     Navigator.of(context).pop();
//                     return;
//                   }

//                   // event.addEventinMySelectedEvents(
//                   //   _selectedDay,
//                   //   Event(
//                   //     id: DateTime.now().toString(),
//                   //     eventName: _eventController.text,
//                   //     dateOfEvent: _selectedDayString,
//                   //   ),
//                   // );

//                   // event.addEvent(
//                   //   Event(
//                   //     id: DateTime.now().toString(),
//                   //     eventName: _eventController.text,
//                   //     dateOfEvent: _selectedDayString,
//                   //   ),
//                   );

// //                  if (event.mySelectedEvents[_selectedDay] != null) {
//                   // _mySelectedEvents[_selectedDay]!.add(
//                   //   Event(
//                   //     id: DateTime.now().toString(),
//                   //     eventName: _eventController.text,
//                   //     dateOfEvent: _selectedDayString,
//                   //   ),
//                   // );
//                   // event.addEventinMySelectedEvents(
//                   //   _selectedDay,
//                   //   Event(
//                   //     id: DateTime.now().toString(),
//                   //     eventName: _eventController.text,
//                   //     dateOfEvent: _selectedDayString,
//                   //   ),
//                   // );
// //                  }
//                   // else {
//                   //   // _mySelectedEvents[_selectedDay] = [
//                   //   //   Event(
//                   //   //     id: DateTime.now().toString(),
//                   //   //     eventName: _eventController.text,
//                   //   //     dateOfEvent: _selectedDayString,
//                   //   //   )
//                   //   // ];
//                   //   event.mySelectedEvents[_selectedDay] = [
//                   //     Event(
//                   //       id: DateTime.now().toString(),
//                   //       eventName: _eventController.text,
//                   //       dateOfEvent: _selectedDayString,
//                   //     )
//                   //   ];
//                   // }

//                   Navigator.of(context).pop();
//                   _eventController.clear();
//                   setState(() {});
//                   return;
//                 },
//               ),
//             ],
//           ),

        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
