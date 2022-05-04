import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

import '../providers/events.dart';

import '../models/event.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  static const routeName = '/add-event-screen';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String _selectedDateString = '';
  DateTime _selectedDate = DateTime.now();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final _events = Provider.of<Events>(context);
    final _newEvent = Event(
      id: DateTime.now().toString(),
      eventName: '',
      //dateOfEvent: DateTime.now(),
      dateOfEvent: '',
    );

    void _saveForm() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }

      _formKey.currentState!.save();

      _events.addEvent(_newEvent);
      _events.addEventinMySelectedEvents(_selectedDate, _newEvent);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new event'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  label: Text('Event name',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w400)),
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
              TextFormField(
                controller: dateController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'DD/MM/YYYY',
                  label: Text('Date of event',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w400)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      showRoundedDatePicker(
                        theme: ThemeData(
                            primaryColor: Theme.of(context).primaryColor),
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1947),
                        lastDate: DateTime(2050),
                        styleDatePicker: MaterialRoundedDatePickerStyle(
                          paddingDatePicker: const EdgeInsets.only(top: 0),
                          paddingMonthHeader:
                              const EdgeInsets.symmetric(vertical: 8),
                          decorationDateSelected: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          textStyleButtonPositive:
                              TextStyle(color: Theme.of(context).primaryColor),
                          textStyleButtonNegative:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ).then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }

                        setState(() {
                          _selectedDateString =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                          dateController =
                              TextEditingController(text: _selectedDateString);
                          _selectedDate = pickedDate;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '* required';
                  }

                  if (!value.contains('/')) {
                    return '* Enter date in correct format';
                  }

                  return null;
                },
                onSaved: (eventDate) {
                  _newEvent.dateOfEvent = _selectedDateString;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
