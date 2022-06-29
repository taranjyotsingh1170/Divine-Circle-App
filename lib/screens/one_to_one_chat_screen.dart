import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';

class OneToOneChatScreen extends StatefulWidget {
  const OneToOneChatScreen(
      {Key? key,
      required this.name,
      required this.receiverName,
      required this.senderName})
      : super(key: key);

  final String name;
  final String receiverName;
  final String senderName;

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  String chatMessage = '';
  //String senderId = FirebaseAuth.instance.currentUser!.uid;

  String getChatId(String receiverName, String senderName) {
    String _groupId;
    String _receiverName = receiverName;
    String _senderId = senderName;

    //_groupId = _receiverName + '_' + _senderId;

    _senderId.hashCode <= _receiverName.hashCode
        ? _groupId = _senderId + '_' + _receiverName
        : _groupId = _receiverName + '_' + _senderId;

    return _groupId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .doc('chatId')
                  .collection(getChatId(widget.receiverName, widget.senderName))
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading...'));
                }
                return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      chatMessage =
                          snapshot.data!.docs[index]['content'].toString();
                      return Bubble(
                        color: Colors.red,
                        borderWidth: 25,
                        nip: BubbleNip.rightTop,
                        alignment: Alignment.centerRight,
                        radius: const Radius.circular(10),
                        margin: const BubbleEdges.all(5),
                        shadowColor: Colors.black,
                        child: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(chatMessage)),
                      );
                    });
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextField(
                    controller: _msgController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      border: InputBorder.none,
                      hintText: 'Type a message',
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                child: IconButton(
                  onPressed: () async {
                    final chatDocId = FirebaseFirestore.instance
                        .collection('Messages')
                        .doc('chatId')
                        .collection(
                            getChatId(widget.receiverName, widget.senderName))
                        .doc()
                        .id;

                    await FirebaseFirestore.instance
                        .collection('Messages')
                        .doc('chatId')
                        .collection(
                            getChatId(widget.receiverName, widget.senderName))
                        .doc(chatDocId)
                        .set({
                      'chatDocId': chatDocId,
                      'receiver_name': widget.receiverName,
                      'sender_name': widget.senderName,
                      'content': _msgController.text,
                      'timestamp': DateTime.now(),
                      'type': 'text',
                      'chatId':
                          getChatId(widget.receiverName, widget.senderName),
                    });

                    _msgController.text = '';

                    // setState(() {
                    //   //chatMessage = _msgController.text;
                    //   _msgController.text = '';
                    // });
                  },
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
