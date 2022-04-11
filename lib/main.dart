import 'package:flutter/material.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/welcome_screen.dart';
import './screens/login_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff134493),
      ),
      home: const WelcomeScreen(),
      //const WelcomeScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
      },
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [],
//         ),
//       ),
//     );
//   }
// }
