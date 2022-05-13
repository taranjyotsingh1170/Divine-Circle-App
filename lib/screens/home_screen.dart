import '/screens/members_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            offset: const Offset(1, 45),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Members'),
                value: 1,
                onTap: () {
                  //Navigator.of(context).pushNamed(MembersScreen.routeName);
                },
              ),
              // const PopupMenuItem(
              //   child: Text('Content Team'),
              //   value: 2,
              // ),
              // const PopupMenuItem(
              //   child: Text('Design Team'),
              //   value: 3,
              // ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.of(context).pushNamed(MembersScreen.routeName);
              }
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
