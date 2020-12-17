import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseCloudFirestore {
  getChats(String roomID) async {
    return Firestore.instance.collection('chatroom').document(roomID).collection('chats').orderBy('timeStamp').snapshots();
  }
  getUserChatsMessages(String myName) async {
    return await Firestore.instance.collection('chatroom').where('users', arrayContains: myName).snapshots();
  }
}
