import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  String sender;
  String content;
  DateTime sentAt;

  MessageModel({
    this.id,
    required this.sender,
    required this.content,
    required this.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MessageModel(
      id: id,
      sender: json['sender'] as String,
      content: json['content'] as String,
      sentAt: (json['sentAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'content': content,
      'sentAt': Timestamp.fromDate(sentAt),
    };
  }
}
