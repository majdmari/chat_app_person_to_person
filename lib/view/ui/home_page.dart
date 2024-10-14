import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign out function
void signOut() {
  //get auth service
  final authService = Provider.of<AuthService>(context, listen: false);
  authService.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }
  // build a list of users except the current logged in user
Widget _buildUserList() {
return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError){
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState==ConnectionState.waiting) {
        return const Text('Loading...');
      }
      return ListView(
        children:snapshot.data!.docs.map<Widget>((doc)=>_buildUserListItem(doc)).toList(),

      );
    });
}
//build invisible user list item
Widget _buildUserListItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //display all users except the current logged in user
  if (_auth.currentUser!.email != data['email']) {
    return ListTile(
      title: Text(data['email']) ,
      onTap:(){
        //pass the clicked user's UID to the chat page
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
          receiverUserEmail:data['email'],
          receiverUserId:data['uid'],
        ),),);
      } ,

    );
  }else{
    return Container();
  }}
}
