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

  static const routeName = '/sub-team-screen';

  @override
  Widget build(BuildContext context) {
    final subTeams = ['Content Team', 'DesignTeam', 'PR Team', 'Kirtan Team'];

    final subTeamsPath = [
      const ContentTeamScreen(),
      const DesignTeamScreen(),
      const PrTeamScreen(),
      const KirtanTeamScreen(),
    ];

    // final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 43,
        title: Text('Sub Teams',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
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
              Container(
                height: 15,
                decoration: const BoxDecoration(
                  color: Color(0xffB9E0F7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 28),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: subTeams.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return subTeamsPath[index];
                            }),
                          );
                        },
                        child: GridTile(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                subTeams[index],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff54545A),
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // child: SizedBox(
                  //   width: deviceSize.width * 0.35,
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: subTeams.length,
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         child: Container(
                  //           height: deviceSize.height * 0.15,

                  //           decoration: BoxDecoration(
                  //             border: Border.all(),
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
