import 'package:flutter/material.dart';

import 'model/chat_data_service.dart';
import 'model/massage_model.dart';

class ChatPage extends StatelessWidget {
  final ChatDatabaseService databaseService = ChatDatabaseService();
  final TextEditingController messageController = TextEditingController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: databaseService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  reverse: true, // Show newest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(message);
                  },
                );
              },
            ),
          ),

          // Message input field
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    return Align(
      alignment: message.sender == "User"
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.sender == "User" ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.sender,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(message.content),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${message.sentAt.hour}:${message.sentAt.minute}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () async {
              if (messageController.text.trim().isNotEmpty) {
                final message = MessageModel(
                  sender: "User", // Replace this with an actual user identifier
                  content: messageController.text.trim(),
                  sentAt: DateTime.now(),
                );
                await databaseService.addMessage(message);
                messageController.clear();
              }
            },
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
