import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/wall_of_fame_screen.dart';
import '../screens/events_screen.dart';
//import '../screens/event_calendar_screen.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hnlo'),
            backgroundColor: Theme.of(context).primaryColor,
          ), ListTile(
            leading: const Icon(Icons.star_outline),
            title:  Text(
              'Home Screen',
              style: GoogleFonts.inter(fontSize: 20,  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(EventsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title:  Text(
              'Wall of Fame',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(WallOfFame.routeName);
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.event),
          //   title:  Text(
          //     'Event Calendar',
          //     style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(EventCalendarScreen.routeName);
          //   },
          // ),
        ],
      ),
    );
  }
}
