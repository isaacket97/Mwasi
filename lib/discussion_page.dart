import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';
import 'user.dart';

class DiscussionPage extends StatefulWidget {
  final CUser user;

  DiscussionPage({required this.user});

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _loggedInUserId;

  final Color sentMessageColor = Color(0xFFFD79A8);
  final Color receivedMessageColor = Color(0x776F364A);

  @override
  void initState() {
    super.initState();
    _loggedInUserId = AuthController.instance.getCurrentUserId();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _firestore.collection('messages').add({
        'text': messageText,
        'senderId': _loggedInUserId,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBDBDBD), // Couleur d'arrière-plan (#BDBDBD)
      appBar: AppBar(
        title: Text('Discussion Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final text = message['text'] as String?;
                      final senderId = message['senderId'] as String?;
                      final isMe = senderId == _loggedInUserId;
                      final messageColor = isMe ? sentMessageColor : receivedMessageColor; // Couleur du message

                      return ListTile(
                        title: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: messageColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              text ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink[200], // Définit une teinte rose pour le bouton d'envoi
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}