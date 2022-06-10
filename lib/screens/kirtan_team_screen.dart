import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KirtanTeamScreen extends StatelessWidget {
  const KirtanTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kirtan Team',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Loading...'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                 if (snapshot.data!.docs[index]['isInKirtanTeam'] == false) {
                  return const SizedBox(height: 0,width: 0);
                }
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                  );
              
                //index = index + 1;
              },
            );
          }
      ),
    );
  }
}
