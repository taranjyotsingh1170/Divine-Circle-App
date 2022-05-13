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
        title: Text(
          'Event Calendar',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._getEventsFromDay(_selectedDay).map(
                    (Event event) => ListTile(
                      title: Text(event.eventName),
                      trailing: Text(event.dateOfEvent),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddEventScreen(selectedDateString: _selectedDayString, selectedDate: _selectedDay,),
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
