import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/screens/content_team_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_drawer.dart';
import 'design_team_screen.dart';
import 'kirtan_team_screen.dart';
import 'pr_team_screen.dart';

class SubTeamScreen extends StatelessWidget {
  const SubTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Teams',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            return Column(
              children: [
                // ignore: unrelated_type_equality_checks
                // if(FirebaseFirestore.instance
                //             .collection('users')
                //             .doc(snapshot.data!.docs[FirebaseAuth.instance.currentUser!.uid]['isInDesignTeam']) ==
                //         true)
                ListTile(
                  title: const Text('Content Team'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ContentTeamScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Design Team'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const DesignTeamScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Public Relations Team'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PrTeamScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Kirtan Team'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const KirtanTeamScreen()),
                    );
                  },
                ),
              ],
            );
          }),
      drawer: const AppDrawer(),
    );
  }
}
