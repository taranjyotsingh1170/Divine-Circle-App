import 'package:flutter/material.dart';

import '../screens/event_calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/events_screen.dart';
import '../screens/profile_screen.dart';
import '/screens/sub_team_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  static const routeName = '/tabs-screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, Widget>> _pages = [];

  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(
          onSeeMoreEventsPressed: (int val) {
            setState(() {
              _selectedPageIndex = val;
            });
          },
        ),
        'title': const Text('Home Screen'),
      },
      {
        'page': const EventsScreen(),
        'title': const Text('Events Screen'),
      },
      {
        'page': const EventCalendarScreen(),
        'title': const Text('Event Calendar Calendar'),
      },
      {
        'page': const SubTeamScreen(),
        'title': const Text('Sub Team Screen'),
      },
      {
        'page': const ProfileScreen(),
        'title': const Text('Profile Screen'),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page']!,

      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
            //indicatorColor: Colors.white.withOpacity(0.8),
            ),
        child: NavigationBar(
          //backgroundColor: Colors.teal,
          animationDuration: const Duration(seconds: 1),
          //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _selectedPageIndex,
          height: 60,
          onDestinationSelected: (index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.event),
              icon: Icon(Icons.event_outlined),
              label: 'Events',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_month),
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Calendar',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.groups),
              icon: Icon(Icons.groups_outlined),
              label: 'Sub Team',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.event),
      //       label: 'Events',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_month_outlined),
      //       label: 'Calendar',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_outlined),
      //       label: 'Profile',
      //     ),
      //   ],
      //   currentIndex: _selectedPage,
      //   unselectedItemColor: Colors.black,
      //   selectedItemColor: Theme.of(context).primaryColor,
      //   unselectedLabelStyle: const TextStyle(color: Colors.black),
      //   onTap: (index) {
      //     setState(() {
      //       _selectedPage = index;
      //     });
      //   },
      //   elevation: 20,
      // ),
    );
  }
}
