import 'package:divine_circle/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Events with ChangeNotifier {
  final List<Event> _eventList = [
    Event(
      id: '1',
      eventName: 'A',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd MMM, yyyy').format(DateTime.now()),
      timeOfEvent: '12 : 30 PM',
      eventDescription:
          'alternatively, we can click on the bubbles representing the members/volunteers so select members if we don\'t want to write email or name... just an alternative but quite useful',
    ),
    Event(
      id: '2',
      eventName: 'B',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd MMM, yyyy').format(DateTime.now()),
      timeOfEvent: '10 : 00 AM',
      eventDescription:
          'its assumed that user(core member) selected 9th may,2022 date and clicked on "create event button" then this whole screen shows up',
    ),
    Event(
      id: '3',
      eventName: 'C',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: DateFormat('dd MMM, yyyy').format(DateTime.now()),
      timeOfEvent: '2 : 00 PM',
      eventDescription:
          'to-do list ki jagah we can write your tasks (these would contain all tasks/roles not event wise, event wise toh event navigation m jaaake exclusively mil jayengey user ko)',
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
}
