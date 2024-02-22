class CUser {
  final String email;
  final String uid;
  final List<Discussion> discussions;

  CUser({required this.email, required this.uid, required this.discussions});

  factory CUser.fromJson(Map<String, dynamic> json) {
    final List<dynamic> discussionsJson = json['discussions'] ?? [];
    final discussions = discussionsJson.map((discussionJson) {
      return Discussion.fromJson(discussionJson);
    }).toList();

    return CUser(
      email: json['email'] as String,
      uid: json['uid'] as String,
      discussions: discussions,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> discussionsMap = discussions.map((discussion) {
      return discussion.toMap();
    }).toList();

    return {
      'email': email,
      'uid': uid,
      'discussions': discussionsMap,
    };
  }
}

class Discussion {
  final String discussionId;
  final List<Message> messages;

  Discussion({required this.discussionId, required this.messages});

  factory Discussion.fromJson(Map<String, dynamic> json) {
    final List<dynamic> messagesJson = json['messages'] ?? [];
    final messages = messagesJson.map((messageJson) {
      return Message.fromJson(messageJson);
    }).toList();

    return Discussion(
      discussionId: json['discussionId'] as String,
      messages: messages,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> messagesMap = messages.map((message) {
      return message.toMap();
    }).toList();

    return {
      'discussionId': discussionId,
      'messages': messagesMap,
    };
  }
}

class Message {
  final String messageId;
  final String text;
  final String senderId;

  Message({required this.messageId, required this.text, required this.senderId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] as String,
      text: json['text'] as String,
      senderId: json['senderId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'text': text,
      'senderId': senderId,
    };
  }
}