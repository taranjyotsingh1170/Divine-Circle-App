import 'package:divine_circle/screens/to_do_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/wall_of_fame_members.dart';
import '../providers/events.dart';
import '/providers/members.dart';

import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/events_screen.dart';
import '../screens/wall_of_fame_screen.dart';
import '../screens/edit_wall_of_fame_screen.dart';
//import 'screens/add_event_screen.dart';
import '../screens/event_calendar_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/tabs_screen.dart';
//import '/screens/event_detail_screen.dart';
import '/screens/members_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(const MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallOfFameMembers()),
        ChangeNotifierProvider(create: (_) => Events()),
        ChangeNotifierProvider(create: (_) => Members()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          //const Locale('th', 'TH'), // Thai
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xff134493),
            appBarTheme: const AppBarTheme(
              color: Color(0xff134493),
            ),
            iconTheme: const IconThemeData(color: Colors.white)),
        home: const WelcomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          EventsScreen.routeName: (ctx) => const EventsScreen(),
          WallOfFame.routeName: (ctx) => const WallOfFame(),
          EditWallOfFameScreen.routeName: (ctx) => const EditWallOfFameScreen(),
          //AddEventScreen.routeName: (ctx) => const AddEventScreen(),
          EventCalendarScreen.routeName: (ctx) => const EventCalendarScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          MembersScreen.routeName: (ctx) => const MembersScreen(),
          //EventDetailScreen.routeName: (ctx) => const EventDetailScreen(),
          ToDoListScreen.routeName: (ctx) => const ToDoListScreen(), 
        },
      ),
    );
  }
}
