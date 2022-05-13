import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../models/event.dart';
import '../providers/events.dart';
import '/providers/members.dart';
//import '../models/member.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen(
      {Key? key, required this.selectedDateString, required this.selectedDate})
      : super(key: key);

  static const routeName = '/add-event-screen';

  final String selectedDateString;
  final DateTime selectedDate;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  //Duration newDuration = const Duration();

  int _hour = DateTime.now().hour;
  String _minutes = '';
  String suffixTime = '';
  TextEditingController _timeController = TextEditingController();
  bool _searchCoordinator = false;
  TextEditingController _coordinatorController = TextEditingController();

  Widget _fieldText(String text) {
    return Text(text,
        style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 18));
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
    _coordinatorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membersList = Provider.of<Members>(context);
    final _events = Provider.of<Events>(context);
    //TextEditingController _dateController = TextEditingController();
    final _newEvent = Event(
      id: DateTime.now().toString(),
      eventName: '',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: '',
      timeOfEvent: '',
      eventDescription: '',
    );
    final GlobalKey<FormState> _formKey = GlobalKey();

    void _saveForm() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      _events.addEvent(_newEvent);
      _events.addEventinMySelectedEvents(widget.selectedDate, _newEvent);

      //print(_newEvent.eventDescription);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create event'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _fieldText('Event Title'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '* required';
                      }
                      return null;
                    },
                    onSaved: (eventName) {
                      _newEvent.eventName = eventName!;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _fieldText('Date'),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: TextEditingController(
                              text: widget.selectedDateString),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (date) {
                            if (date!.isEmpty) {
                              return '* required';
                            }
                            return null;
                          },
                          onSaved: (date) {
                            _newEvent.dateOfEvent = widget.selectedDateString;
                          },
                        ),
                      ),
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(width: 12)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _fieldText('Time'),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _timeController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (time) {
                            if (time!.isEmpty) {
                              return '* required';
                            }
                            return null;
                          },
                          onSaved: (time) {
                            _newEvent.timeOfEvent = time!;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              height: 220,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (dateTime) {
                                  // print(
                                  //     '${dateTime.hour} : ${DateFormat('mm').format(dateTime)}');
                                  setState(() {
                                    // _hour =
                                    //     dateTime.hour == 0 ? 12 : dateTime.hour;

                                    if (dateTime.hour <= 12 &&
                                        dateTime.hour > 0) {
                                      _hour = dateTime.hour;
                                    } else if (dateTime.hour > 12) {
                                      _hour = dateTime.hour - 12;
                                    } else if (dateTime.hour == 0) {
                                      _hour = 12;
                                    }

                                    _minutes =
                                        DateFormat('mm').format(dateTime);
                                    suffixTime =
                                        dateTime.hour >= 12 ? 'PM' : 'AM';

                                    _timeController = TextEditingController(
                                        text: '$_hour : $_minutes $suffixTime');
                                  });
                                },
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _timeController =
                                              TextEditingController();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        //print(_timeController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'))
                                ],
                              )
                            ],
                          ),
                          // TimePickerSpinner(
                          //       is24HourMode: false,
                          //       normalTextStyle: const TextStyle(
                          //           fontSize: 24, color: Colors.deepOrange),
                          //       highlightedTextStyle: const TextStyle(
                          //           fontSize: 24, color: Colors.yellow),
                          //       spacing: 50,
                          //       itemHeight: 80,
                          //       isForce2Digits: true,
                          //       onTimeChange: (time) {
                          //         setState(() {
                          //           _dateTime = time;
                          //         });
                          //       },
                          //     )

                          // CupertinoDatePicker(
                          //   mode: CupertinoDatePickerMode.time,
                          //   onDateTimeChanged: (dateTime) {},

                          // ),
                        ),
                      ),
                      //const SizedBox(width: 2)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _fieldText('Event Description'),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    //autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (eventDescription) {
                      if (eventDescription!.isEmpty) {
                        return '* required';
                      }
                      return null;
                    },
                    onSaved: (eventDescription) {
                      _newEvent.eventDescription = eventDescription!;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                _fieldText('Add Event Managers'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          // validator: (eventManagers) {
                          //   if (value!.isEmpty) {
                          //     return '* required';
                          //   }
                          //   return null;
                          // },
                          onSaved: (eventManagers) {
                            //_newEvent.eventName = eventName!;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          showSearch(
                              context: context, delegate: MySearchDelegate());
                        },
                      ),
                      const SizedBox(width: 8)
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _fieldText('Add Event Coordinators'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _coordinatorController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          // validator: (eventCoordinators) {
                          //   if (eventCoordinators!.isEmpty) {
                          //     return '* required';
                          //   }
                          //   return null;
                          // },
                          onSaved: (eventDescription) {
                            //_newEvent.eventName = eventName!;
                          },
                        ),
                      ),
                      _searchCoordinator == false
                          ? IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _searchCoordinator = !_searchCoordinator;
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchCoordinator = !_searchCoordinator;
                                });
                                if (_coordinatorController.text.isNotEmpty) {
                                  _coordinatorController.clear();
                                }
                              },
                            ),
                    ],
                  ),
                ),
                if (_searchCoordinator)
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        itemCount: membersList
                            .suggestionList(_coordinatorController.text)
                            .length,
                        itemBuilder: (context, index) {
                          final suggestion = membersList.suggestionList(
                              _coordinatorController.text)[index];

                          return ListTile(
                            title: Text(suggestion.name),
                            onTap: () {
                              // _coordinatorController = TextEditingController(text: suggestion.name);
                              setState(() {
                                //print(suggestion.name);
                                _coordinatorController = TextEditingController(
                                    text: suggestion.name);
                              });
                            },
                          );
                        }),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: _fieldText('Save'),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    primary: Theme.of(context).primaryColor,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
    //throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
    //throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final membersList = Provider.of<Members>(context);
    return ListView.builder(
        itemCount: membersList.suggestionList(query).length,
        itemBuilder: (context, index) {
          final suggestion = membersList.suggestionList(query)[index];
          return ListTile(
            title: Text(suggestion.name),
            onTap: () {
              query = suggestion.name;
            },
          );
        });
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
    //throw UnimplementedError();
  }
}
