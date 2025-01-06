import 'package:cloud_firestore/cloud_firestore.dart';

import 'massage_model.dart';


class ChatDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection name for chat messages
  static const String _messagesCollection = "messages";

  // Fetch messages in real-time (ordered by timestamp)
  Stream<List<MessageModel>> getMessages() {
    return _firestore
        .collection(_messagesCollection)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();
    });
  }

  // Add a new message to the database
  Future<void> addMessage(MessageModel message) async {
    await _firestore.collection(_messagesCollection).add(message.toJson());
  }
}
