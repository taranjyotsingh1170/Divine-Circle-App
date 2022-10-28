import 'package:divine_circle/screens/create_chat_group.dart';
import 'package:divine_circle/screens/home_search_screen.dart';
import 'package:divine_circle/screens/one_to_one_chat_members_screen.dart';
import 'package:divine_circle/screens/paths_screen.dart';
import 'package:divine_circle/screens/sub_team_screen.dart';
import 'package:divine_circle/screens/to_do_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/login.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = const WelcomeScreen();
  Login login = Login();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await login.getToken();
    if (token != null) {
      setState(() {
        currentPage = const TabsScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallOfFameMembers()),
        ChangeNotifierProvider(create: (_) => Events()),
        ChangeNotifierProvider(create: (_) => Members()),
        ChangeNotifierProvider(create: (_) => Login())
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
            primaryColor: const Color(0xffB9E0F7),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xffB9E0F7),
              //color: Color(0xff134493),
            ),
            iconTheme: const IconThemeData(color: Color(0xff54545A))),
        //home: const HomeScreen(),
        home: currentPage,
        // home: const WelcomeScreen(),
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
          CreateGroupChat.routeName: (ctx) => const CreateGroupChat(),
          SubTeamScreen.routeName: (ctx) => const SubTeamScreen(),
          OneToOneChatMembersScreen.routeName: (ctx) =>
              const OneToOneChatMembersScreen(),
          PathsScreen.routeName: (ctx) => const PathsScreen(),
          HomeSearchScreen.routeName: (ctx)=> const HomeSearchScreen()
        },
      ),
    );
  }
}
