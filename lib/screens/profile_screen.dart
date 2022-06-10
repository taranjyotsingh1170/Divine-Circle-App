import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Profile',style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
                iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: const AppDrawer(),
    );
  }
}
