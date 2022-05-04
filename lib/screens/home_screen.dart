//import 'package:divine_circle/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/add_event_screen.dart';

import '../widgets/app_drawer.dart';

import '../providers/events.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final _events = Provider.of<Events>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddEventScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (ctx, index) => const Divider(),
        itemCount: _events.eventList.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(_events.eventList[index].eventName),
          trailing: Text((_events.eventList[index].dateOfEvent)
          //trailing: Text(DateFormat('dd/MM/yyyy').format(_events.eventList[index].dateOfEvent)),
        ),
        
      ),
      ),
      drawer: const AppDrawer(),
      // bottomNavigationBar: const TabsScreen(),
    )
    ;
  }
}
