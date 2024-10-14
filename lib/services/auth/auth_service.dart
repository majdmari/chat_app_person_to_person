import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// sign user in
Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
  try {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password
    );
    //add new document for the user in users collection if it does not already exist
    _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email
    },
    SetOptions(merge: true),
    );
    return userCredential;
  }
//catch any error
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }

}

// sign user out
Future<void> signOut() async{
  return await FirebaseAuth.instance.signOut();
}

//create new user
Future<UserCredential> SignUpWithEmailAndPassword(String email, String password) async{
  try {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password
    );

    //after creating user,create a new document for the user in users collection
    _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email
    });


    return userCredential;
  }
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }

}
}