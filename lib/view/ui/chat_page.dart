import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/view/widget/chat_bubble.dart';
import 'package:chat_app/view/widget/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({super.key,
    required this.receiverUserId,
    required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverUserId, _messageController.text);
      //clear the message after sending
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessagesList(),
          ),

          //user input
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

//build messages list
  Widget _buildMessagesList() {
    return StreamBuilder(stream: _chatServices.getMessages(
        widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context,snapshot){
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error.toString()}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }
      return ListView(
        children: snapshot.data!.docs.map((document) => _buildMessagesItem(document)).toList(),

      );
      },);
  }

//build message item
  Widget _buildMessagesItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
// align the message to the right if the sender is the current user,otherwise align it to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)?CrossAxisAlignment.end:CrossAxisAlignment.start,
          mainAxisAlignment:  (data['senderId'] == _firebaseAuth.currentUser!.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            (data['senderId'] == _firebaseAuth.currentUser!.uid)? ChatBubble (measage: data['message'],color: Colors.blue,):ChatBubble (measage: data['message'],color: Colors.green,),
          ],
        ),
      ),
    );
  }

//build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          //text field
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
            ),
          ),
          //send button
          IconButton(
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
