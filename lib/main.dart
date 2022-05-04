
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../providers/members.dart';
import '../providers/events.dart';

import 'screens/welcome_screen.dart';
import './screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/wall_of_fame_screen.dart';
import '../screens/edit_wall_of_fame_screen.dart';
import '../screens/add_event_screen.dart';
import '../screens/event_calendar_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/tabs_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => Members()),
        ChangeNotifierProvider(create: (_) => Events()),
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
        ),
        home: const WelcomeScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          WallOfFame.routeName: (ctx) => const WallOfFame(),
          EditWallOfFameScreen.routeName: (ctx) => const EditWallOfFameScreen(),
          AddEventScreen.routeName: (ctx) => const AddEventScreen(),
          EventCalendarScreen.routeName: (ctx)=> const EventCalendarScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          ProfileScreen.routeName: (ctx)=> const ProfileScreen(),
        },
      ),
    );
  }
}
