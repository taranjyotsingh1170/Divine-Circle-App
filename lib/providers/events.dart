import 'package:divine_circle/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Events with ChangeNotifier {
  final List<Event> _eventList = [
    Event(
      id: '1',
      eventName: 'A',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    ),
    Event(
      id: '2',
      eventName: 'B',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    ),
    Event(
      id: '3',
      eventName: 'C',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    ),
  ];

  List<Event> get eventList {
    return [..._eventList];
  }

  void addEvent(Event newEvent) {
    _eventList.add(newEvent);
    _eventList.sort(
        ((event1, event2) => event1.dateOfEvent.compareTo(event2.dateOfEvent)));
    notifyListeners();
  }

  // void sortEvents(Event newEvent) {
  //   _eventList.sort(
  //       ((event1, event2) => event1.dateOfEvent.compareTo(event2.dateOfEvent)));
  // }

  final Map<DateTime, List<Event>> _mySelectedEvents = {};

  Map<DateTime, List<Event>> get mySelectedEvents {
    return _mySelectedEvents;
  }

  void addEventinMySelectedEvents(DateTime selectedDay, Event newEvent) {
    if (_mySelectedEvents[selectedDay] != null) {
      _mySelectedEvents[selectedDay]!.add(newEvent);
      // _eventList.add(newEvent);
    } else {
      _mySelectedEvents[selectedDay] = [newEvent];
      // _eventList.add(newEvent);
    }

    notifyListeners();
  }

  // DateTime _date = DateTime.now();

  // DateTime get date {
  //   return _date;
  // }

  // List<Event> get getEventsFromDay {
  //   return _mySelectedEvents[_date] ?? [];
  //   //return event.mySelectedEvents[date] ?? [];
  // }
}
