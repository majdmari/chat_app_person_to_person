import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receicerId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.receicerId,
      required this.message,
      required this.timestamp});
  //convert to a map
Map<String,dynamic> toMap(){
  return {
    'senderId':senderId,
    'senderEmail':senderEmail,
    'receicerId':receicerId,
    'message':message,
    'timestamp':timestamp,
  };
}
}
