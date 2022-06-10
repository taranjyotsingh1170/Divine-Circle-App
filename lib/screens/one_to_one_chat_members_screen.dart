import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/screens/one_to_one_chat_screen.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OneToOneChatMembersScreen extends StatelessWidget {
  const OneToOneChatMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One to one chat',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Loading...'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length ,
                itemBuilder: (ctx, index) {
                  if (snapshot.data!.docs[index]['id'] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return const SizedBox(height: 0, width: 0);
                    //index = index + 1;
                  }
                  return ListTile(
                    title: Text(snapshot.data!.docs[index]['name']),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OneToOneChatScreen(
                          name: snapshot.data!.docs[index]['name'],
                          //receiverId: snapshot.data!.docs[index]['id'],
                          receiverName: snapshot.data!.docs[index]['name'],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
