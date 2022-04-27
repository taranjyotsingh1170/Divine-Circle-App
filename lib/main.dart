import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/welcome_screen.dart';
import './screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/wall_of_fame_screen.dart';
import '../screens/edit_wall_of_fame_screen.dart';

import '../providers/members.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
        },
      ),
    );
  }
}
