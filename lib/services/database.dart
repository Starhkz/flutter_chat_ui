import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_ui/models/message_model.dart';
import 'package:flutter_chat_ui/models/user_model.dart';

class DatabaseService {
  final String uid;
  final String friendUid;

  DatabaseService({this.uid, this.friendUid});
  // Collection reference

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  Future updateUserData(String uid, String name, String imageUrl) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name ?? 'Unknown',
      'imageUrl': imageUrl,
    });
  }

  Future uploadMessage(String send, String receiver, String time, String text,
      bool isLiked, bool unread) async {
    return await messageCollection
        .doc(uid)
        .collection(friendUid)
        .doc(time)
        .set({
      'send': uid,
      'receiver': friendUid,
      'time': time,
      'text': text,
      'isLiked': isLiked,
      'unread': unread
    });
  }

  Future uploadFriendMessage(String send, String receiver, String time,
      String text, bool isLiked, bool unread) async {
    return await messageCollection
        .doc(friendUid)
        .collection(uid)
        .doc(time)
        .set({
      'send': uid,
      'receiver': friendUid,
      'time': time,
      'text': text,
      'isLiked': isLiked,
      'unread': unread
    });
  }

  Future uploadChatList(
      String time, bool unread, String text, String imageUrl) async {
    return await messageCollection
        .doc(uid)
        .collection('Chat List')
        .doc(time)
        .set({
      'chatUid': friendUid,
      'text': text,
      'unread': unread,
      'imageUrl': imageUrl,
      'time': time
    });
  }

  Future uploadFriendChatList(
      String time, bool unread, String text, String imageUrl) async {
    return await messageCollection
        .doc(friendUid)
        .collection('Chat List')
        .doc(time)
        .set({
      'chatUid': uid,
      'text': text,
      'unread': unread,
      'imageUrl': imageUrl,
      'time': time
    });
  }

  Future updateUser(String uids, String name, String imageUrl) async {
    return await userCollection
        .doc(uid)
        .update({
          'uid': uid,
          'name': name,
          'imageUrl': imageUrl,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future updateChatList(
    String time,
    bool unread,
  ) async {
    return await messageCollection
        .doc(uid)
        .collection('Chat List')
        .doc(time)
        .update({'unread': unread, 'time': time});
  }

  Future updateFriendChatList(String time, bool unread) async {
    return await messageCollection
        .doc(friendUid)
        .collection('Chat List')
        .doc(time)
        .update({
      'unread': unread,
    });
  }

  Future updateMessage(String time, bool isLiked, bool unread) async {
    return await messageCollection
        .doc(uid)
        .collection(friendUid)
        .doc(time)
        .update({'isLiked': isLiked, 'unread': unread});
  }

  Future updateFriendMessage(String time, bool isLiked, bool unread) async {
    return await messageCollection
        .doc(friendUid)
        .collection(uid)
        .doc(time)
        .update({'isLiked': isLiked, 'unread': unread});
  }

  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return User(
          name: doc.data()['name'] ?? 'No Name',
          uid: doc.data()['uid'] ?? null,
          imageUrl: doc.data()['imageUrl'] ?? null);
    }).toList();
  }

  // Use
  List<Message> _userDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
          receiver: doc.data()['receiver'] ?? '',
          send: doc.data()['send'] ?? '',
          time: doc.data()['time'] ?? '',
          text: doc.data()['text'] ?? '',
          isLiked: doc.data()['isLiked'] ?? false,
          unread: doc.data()['unread'] ?? true);
    }).toList();
  }

  List<Chat> _chatListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chat(
          chatUid: doc.data()['chatUid'] ?? '',
          time: doc.data()['time'] ?? '',
          text: doc.data()['text'] ?? '',
          imageUrl: doc.data()['imageUrl'] ?? '',
          unread: doc.data()['unread'] ?? true);
    }).toList();
  }

  String _userNameFromUid(DocumentSnapshot snapshot) {
    return snapshot.data()['name'].toString();
  }

  User _currentUserFromSnapshot(DocumentSnapshot snapshot) {
    return User(
        name: snapshot.data()['name'] ?? 'No Name',
        uid: snapshot.data()['uid'] ?? null,
        imageUrl: snapshot.data()['imageUrl'] ?? null);
  }

  // Get brews sstream
  Stream<List<User>> get favUser {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Message>> get friendMessage {
    return messageCollection
        .doc(uid)
        .collection(friendUid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Stream<List<Chat>> get chatList {
    return messageCollection
        .doc(uid)
        .collection('Chat List')
        .snapshots()
        .map(_chatListFromSnapshot);
  }

  Stream<String> get userName {
    return userCollection.doc(friendUid).snapshots().map(_userNameFromUid);
  }

  Stream<User> get myData {
    return userCollection.doc(uid).snapshots().map(_currentUserFromSnapshot);
  }
  // Stream<List<Chat>> get chatList {
  //   return messageCollection
  //       .doc(uid)
  //       .snapshots()
  //       .map(_userChatListFromSnapshot);
  // }
}

//  final String send;
//   final String time;
//   final String text;
//   final bool unread;
//   final String imageUrl;
