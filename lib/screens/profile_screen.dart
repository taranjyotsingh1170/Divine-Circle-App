import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';

  String name() {
    // ignore: unused_local_variable
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        username = fields!['name'];
      });
    });
    return username;
  }

  Widget userTeamContainer(String teamName) {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffD9D9D9), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            teamName,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: const Color(0xff54545A),
                fontSize: 16,
                letterSpacing: -0.5),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
          ),
        ),
        const SizedBox(width: 12)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: deviceSize.height * 0.3,
              width: deviceSize.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffCCE8F9), Color(0xffffffff)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 90),
                Container(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  // width: deviceSize.width,
                  child: SizedBox(
                    width: deviceSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profile',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff333333),
                              fontSize: 28,
                              letterSpacing: -0.8),
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/edit_profile.png',
                            height: 28,
                            width: 28,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 28, right: 28, bottom: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage('assets/images/TJ.jpg')),
                      const SizedBox(height: 11),
                      Text(
                        name(),
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff54545A),
                            fontSize: 18,
                            letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Volunteer',
                        style: GoogleFonts.inter(
                            // fontWeight: FontWeight.w500,
                            color: const Color(0xff54545A),
                            fontSize: 18,
                            letterSpacing: -0.5),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            }

                            if (snapshot.data!['isInContentTeam'] ||
                                snapshot.data!['isInDesignTeam'] ||
                                snapshot.data!['isInKirtanTeam'] ||
                                snapshot.data!['isInPrTeam']) {
                              return Column(
                                children: [
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    height: deviceSize.height * 0.1,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: [
                                        if (snapshot.data!['isInContentTeam'])
                                          userTeamContainer('Content Team'),
                                        if (snapshot.data!['isInDesignTeam'])
                                          userTeamContainer('Design Team'),
                                        if (snapshot.data!['isInKirtanTeam'])
                                          userTeamContainer('Kirtan Team'),
                                        if (snapshot.data!['isInPrTeam'])
                                          userTeamContainer('PR Team')
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32)
                                ],
                              );
                            }

                            return const SizedBox(height: 11);
                          }),
                    ],
                  ),
                ),
                const Divider(color: Color(0xffD9D9D9), thickness: 1.5),
                const SizedBox(height: 9),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: TabBar(
                    labelPadding: const EdgeInsets.only(bottom: 9),
                    indicatorColor: const Color(0xff3f5c8c),
                    tabs: [
                      Tab(
                        child: Text(
                          'Active Events',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff54545A),
                              fontSize: 16,
                              letterSpacing: -0.5),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Past Events',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff54545A),
                              fontSize: 16,
                              letterSpacing: -0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Current Events List
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('List of Events')
                              .where('event date',
                                  isGreaterThanOrEqualTo: DateTime.now())
                              .where('event coordinators',
                                  arrayContains: username)
                              .orderBy('event date')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text(''));
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text('No event added yet!'),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                      color: Color(0xffD9D9D9), thickness: 1),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(
                                  snapshot.data!.docs[index]['event title'],
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.7,
                                    color: const Color(0xff54545A),
                                  ),
                                ),
                                trailing: Text(
                                  DateFormat('dd MMM, yyyy').format(snapshot
                                      .data!.docs[index]['event date']
                                      .toDate()),
                                  style: GoogleFonts.inter(
                                    // fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: -0.7,
                                    color: const Color(0xff54545A),
                                  ),
                                ),
                              ),
                            );
                          }),

                      // Past Events List
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('List of Events')
                            .where('event date',
                                isLessThan: DateFormat('dd MMM, yyyy')
                                    .format(DateTime.now()))
                            .where('event coordinators',
                                arrayContains: username)
                            .orderBy('event date')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Center(child: Text('')),
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No event added yet!'),
                            );
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                                color: Color(0xffD9D9D9), thickness: 1),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                snapshot.data!.docs[index]['event title'],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: -0.7,
                                  color: const Color(0xff54545A),
                                ),
                              ),
                              trailing: Text(
                                DateFormat('dd MMM, yyyy').format(snapshot
                                    .data!.docs[index]['event date']
                                    .toDate()),
                                style: GoogleFonts.inter(
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  letterSpacing: -0.7,
                                  color: const Color(0xff54545A),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
