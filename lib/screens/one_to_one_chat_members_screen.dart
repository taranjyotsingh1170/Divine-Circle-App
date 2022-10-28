import 'package:divine_circle/screens/create_chat_group.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/screens/one_to_one_chat_screen.dart';

class OneToOneChatMembersScreen extends StatelessWidget {
  const OneToOneChatMembersScreen({Key? key}) : super(key: key);

  static const routeName = '/chat-members-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One to one chat',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.black)),
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
            String senderName = '';
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((value) {
              var fields = value.data();
              senderName = fields!['name'];
            });
            return ListView.builder(
              itemCount: snapshot.data!.docs.length - 1,
              itemBuilder: (ctx, index) {
                if (snapshot.data!.docs[index]['id'] ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  index = index + 1;
                }
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['name']),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OneToOneChatScreen(
                        name: snapshot.data!.docs[index]['name'],
                        //receiverId: snapshot.data!.docs[index]['id'],
                        receiverName: snapshot.data!.docs[index]['name'],
                        senderName: senderName,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateGroupChat.routeName);
        },
      ),
    );
  }
}
