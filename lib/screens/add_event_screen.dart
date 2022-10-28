import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../models/event.dart';
import '../providers/events.dart';
// import '/providers/members.dart';
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
  // int _hour = DateTime.now().hour;
  // String _minutes = '';
  String suffixTime = '';
  TextEditingController _timeController = TextEditingController();
  DateTime selectedTime = DateTime.now();
  bool _searchCoordinator = false;
  final TextEditingController _coordinatorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  //String currentUserName= '';
  FocusNode searchCoordinatorFocus = FocusNode();
  FocusNode titleFocus = FocusNode();
  bool isCoordinatorSelected = false;
  List selectedCoordinatorsIdList = [];
  List selectedCoordinatorsNames = [];

  final _newEvent = Event(
    id: DateTime.now().toString(),
    eventName: '',
    dateOfEvent: DateTime.now(),
    timeOfEvent: '',
    eventDescription: '',
  );

  Widget _fieldText(String text) {
    return Text(text,
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            letterSpacing: -0.7,
            color: const Color(0xff54545A)));
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  onSearchChanged() {
    setState(() {});
  }

  Widget coordinators(snapshot, index, isSelectedForDuty) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Text(snapshot.data!.docs[index]['name']),
      trailing: isSelectedForDuty
          ? IconButton(
              icon: const Icon(Icons.check_circle_rounded),
              onPressed: () {},
            )
          : null,
      onTap: () {
        isSelectedForDuty = !isSelectedForDuty;

        FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data!.docs[index]['id'])
            .update({'isSelectedForDuty': isSelectedForDuty});

        if (!isSelectedForDuty) {
          setState(() {
            selectedCoordinatorsIdList.remove(snapshot.data!.docs[index]['id']);
            selectedCoordinatorsNames
                .remove(snapshot.data!.docs[index]['name']);
          });
        } else {
          setState(() {
            selectedCoordinatorsIdList.add(snapshot.data!.docs[index]['id']);
            selectedCoordinatorsNames.add(snapshot.data!.docs[index]['name']);
            // selectedCoordinatorsList
            //     .clear();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
    _coordinatorController.dispose();
    searchCoordinatorFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final membersList = Provider.of<Members>(context);
    final _events = Provider.of<Events>(context);
    Size deviceSize = MediaQuery.of(context).size;

    void _saveForm(String currentUserName) {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();
      //_events.addEvent(_newEvent);
      _events.addEventinMySelectedEvents(widget.selectedDate, _newEvent);
      //print(currentUserName);
      final docId =
          FirebaseFirestore.instance.collection('List of Events').doc().id;
      //print(docId);
      // setSearchParameter(String eventTitle) {
      //   List<String> caseSearchList = [];
      //   String temp = '';
      //   String lowerTemp = '';
      //   for (int i = 0; i < eventTitle.length; i++) {
      //     temp = temp + eventTitle[i];
      //     caseSearchList.add(temp);
      //     if (eventTitle[i] == eventTitle[i].toUpperCase()) {
      //       // print(eventTitle[i].toUpperCase());
      //       lowerTemp = lowerTemp + eventTitle[i].toLowerCase();
      //       // print(eventTitle[i].toLowerCase());
      //       caseSearchList.add(lowerTemp);
      //     }
      //   }
      //   return caseSearchList;
      // }

      try {
        FirebaseFirestore.instance.collection('List of Events').doc(docId).set({
          'id': docId,
          'event title': _newEvent.eventName,
          'event date': _newEvent.dateOfEvent,
          'event time': _newEvent.timeOfEvent,
          'event description': _newEvent.eventDescription,
          'event added by': currentUserName,
          'event added on': DateTime.now(),
          // 'case search': setSearchParameter(_newEvent.eventName),
          'event coordinators': selectedCoordinatorsNames,
        });

        FirebaseFirestore.instance.collection('users').get().then((value) {
          for (DocumentSnapshot docs in value.docs) {
            docs.reference.update({'isSelectedForDuty': false});
          }
        });
      } catch (error) {
        //print(error);
      }
      //print(docId);
      Navigator.of(context).pop();
    }

    if (_searchCoordinator) {
      searchCoordinatorFocus.requestFocus();
    } else {
      searchCoordinatorFocus.unfocus();
    }

    return WillPopScope(
      onWillPop: () async {
        FirebaseFirestore.instance.collection('users').get().then((value) {
          for (DocumentSnapshot docs in value.docs) {
            docs.reference.update({'isSelectedForDuty': false});
          }
        });
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Stack(
            children: [
              Container(
                height: deviceSize.height * 0.3,
                width: deviceSize.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffCCE8F9), Color(0xffffffff)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 90),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 28, right: 28, bottom: 1),
                    width: deviceSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Image.asset('assets/images/arrow_back_ios.png',
                              height: 30, width: 30),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(
                          width: deviceSize.width * 0.2,
                        ),
                        Text(
                          'Create Event',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff333333),
                              fontSize: 22,
                              letterSpacing: -0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 38),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  _fieldText('Event Title'),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xfff0f0f0)),
                                    child: TextFormField(
                                      controller: _titleController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          border: InputBorder.none),
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _fieldText('Date'),
                                          const SizedBox(height: 5),
                                          Container(
                                            width: deviceSize.width * 0.38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xfff0f0f0)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        TextEditingController(
                                                            text: widget
                                                                .selectedDateString),
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(15),
                                                      border: InputBorder.none,
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    validator: (date) {
                                                      if (date!.isEmpty) {
                                                        return '* required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (date) {
                                                      _newEvent.dateOfEvent =
                                                          widget.selectedDate;
                                                    },
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 12)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _fieldText('Time'),
                                          const SizedBox(height: 5),
                                          Container(
                                            width: deviceSize.width * 0.38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xfff0f0f0)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller: _timeController,
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(15),
                                                      border: InputBorder.none,
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    validator: (time) {
                                                      if (time!.isEmpty) {
                                                        return '* required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (time) {
                                                      _newEvent.timeOfEvent =
                                                          time!;
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      content: SizedBox(
                                                        height: 220,
                                                        child:
                                                            CupertinoDatePicker(
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .time,
                                                          onDateTimeChanged:
                                                              (dateTime) {
                                                            // print(DateFormat('hh:mm a').format(dateTime));
                                                            setState(() {
                                                              _timeController = TextEditingController(
                                                                  text: DateFormat(
                                                                          'hh:mm a')
                                                                      .format(
                                                                          dateTime));
                                                            });
                                                            // print(
                                                            //     '${dateTime.hour} : ${DateFormat('mm').format(dateTime)}');
                                                            //   setState(
                                                            //     () {
                                                            //       // _hour =
                                                            //       //     dateTime.hour == 0 ? 12 : dateTime.hour;

                                                            //       if (dateTime.hour <=
                                                            //               12 &&
                                                            //           dateTime.hour >
                                                            //               0) {
                                                            //         _hour = dateTime
                                                            //             .hour;
                                                            //       } else if (dateTime
                                                            //               .hour >
                                                            //           12) {
                                                            //         _hour = dateTime
                                                            //                 .hour -
                                                            //             12;
                                                            //       } else if (dateTime
                                                            //               .hour ==
                                                            //           0) {
                                                            //         _hour = 12;
                                                            //       }

                                                            //       _minutes = DateFormat(
                                                            //               'mm')
                                                            //           .format(
                                                            //               dateTime);
                                                            //       suffixTime =
                                                            //           dateTime.hour >=
                                                            //                   12
                                                            //               ? 'PM'
                                                            //               : 'AM';

                                                            //       _timeController =
                                                            //           TextEditingController(
                                                            //               text:
                                                            //                   '$_hour : $_minutes $suffixTime');
                                                            //     },
                                                            //   );
                                                          },
                                                        ),
                                                      ),
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    _timeController =
                                                                        TextEditingController();
                                                                  },
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'OK'),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  _fieldText('Event Description'),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xfff0f0f0)),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: InputBorder.none,
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      validator: (eventDescription) {
                                        if (eventDescription!.isEmpty) {
                                          return '* required';
                                        }
                                        return null;
                                      },
                                      onSaved: (eventDescription) {
                                        _newEvent.eventDescription =
                                            eventDescription!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  _fieldText('Add Event Managers'),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xfff0f0f0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: const InputDecoration(
                                              hintText: 'Search',
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              border: InputBorder.none,
                                            ),
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.done,
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
                                                context: context,
                                                delegate: MySearchDelegate());
                                          },
                                        ),
                                        const SizedBox(width: 8)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  _fieldText('Add Event Coordinators'),
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xfff0f0f0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            focusNode: searchCoordinatorFocus,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: _coordinatorController,
                                            decoration: const InputDecoration(
                                              hintText: 'Search',
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              onSearchChanged();
                                            },
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.search,
                                            onFieldSubmitted: (value) {
                                              searchCoordinatorFocus.unfocus();
                                            },
                                            onTap: () {
                                              setState(() {
                                                _searchCoordinator = true;
                                              });
                                            },
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
                                                  setState(
                                                    () {
                                                      _searchCoordinator =
                                                          !_searchCoordinator;
                                                    },
                                                  );
                                                },
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      _searchCoordinator =
                                                          !_searchCoordinator;
                                                    },
                                                  );
                                                  if (_coordinatorController
                                                      .text.isNotEmpty) {
                                                    _coordinatorController
                                                        .clear();
                                                  }
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    height: deviceSize.height * 0.1,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            selectedCoordinatorsNames.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 120,
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Text(
                                                selectedCoordinatorsNames[
                                                    index]),
                                          );
                                        }),
                                  ),
                                  const SizedBox(height: 18),
                                  if (_searchCoordinator)
                                    Container(
                                      color: Colors.amber,
                                      height: 160,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream:
                                            // _coordinatorController.text.isEmpty
                                            //     ?
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .snapshots(),
                                        // : FirebaseFirestore.instance
                                        //     .collection('users')
                                        //     .where('case search',
                                        //         arrayContains:
                                        //             _coordinatorController
                                        //                 .text)
                                        //     .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Text('No data');
                                          }

                                          return ListView.builder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              bool isSelectedForDuty =
                                                  snapshot.data!.docs[index]
                                                      ['isSelectedForDuty'];

                                              if (_coordinatorController
                                                  .text.isEmpty) {
                                                return coordinators(snapshot,
                                                    index, isSelectedForDuty);
                                              }
                                              if (snapshot
                                                  .data!.docs[index]['name']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      _coordinatorController
                                                          .text
                                                          .toLowerCase())) {
                                                return coordinators(snapshot,
                                                    index, isSelectedForDuty);
                                              }
                                              return const SizedBox();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 23),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get()
                                  .then((value) {
                                var fields = value.data();
                                var currentName = fields!['name'];
                                _saveForm(currentName);
                              });
                            } catch (error) {
                              //print(error);
                            }
                          },
                          child: Text('Save',
                              style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff405c8c)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(400, 50)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  // List get searchResults {
  //   List users = [];
  //   FirebaseFirestore.instance.collection('users').get().then((value) {
  //     for (DocumentSnapshot docs in value.docs) {
  //       users.add(docs);
  //     }
  //   });
  //   // print(users);
  //   return users;
  // }

  // List suggestionList(String query) {
  //   return searchResults.where((searchResult) {
  //     final result = searchResult['name'].toLowerCase();
  //     final input = query.toLowerCase();
  //     return result.contains(input);
  //   }).toList();
  //   //return [];
  // }

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
    // final membersList = Provider.of<Members>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(''),
            );
          }
          // final results =
          //     snapshot.data!.docs.where((DocumentSnapshot a) => a.data['title'].contains(query));
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              // itemCount: suggestionList(query).length,
              itemBuilder: (context, index) {
                // final suggestion = suggestionList(query)[index];
                // return ListTile(
                //   title: Text(snapshot.data!.docs[index]['name']),
                //   // title: Text(suggestion.name),
                //   // onTap: () {
                //   //   query = suggestion.name;
                //   // },
                // );

                if (query.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                if (snapshot.data!.docs[index]['name']
                    .toString()
                    .toLowerCase()
                    .contains(query)) {
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
                }

                return const SizedBox();
              });
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
