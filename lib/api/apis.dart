import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self Information
  static late ChatUser me;

  // getting current user
  static User get user => auth.currentUser!;

  // for checking weather the user exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for getting current user info from firebase
  static Future<void> getSelfInfo() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hello!, I'm using We chat ",
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: false,
        email: user.email.toString(),
        pushToken: "");

    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // for getting all users from firestore database leaving us
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    // for getting file extension
    final ext = file.path.split(".").last;
    log("Extension: $ext");

    // storage file ref with path
    final ref = storage.ref().child("profile_picture/${user.uid}.$ext");

    // uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
        (p0) => {log("Data transferred: ${p0.bytesTransferred / 1000} kb")});

    // updating image in firebase database
    me.image = await ref.getDownloadURL();
    await firestore.collection("users").doc(user.uid).update({
      "image": me.image,
    });
  }

  ///*********** Chat screen related API's ***********

  //useful for getting conservation id
  static String getConservationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

// for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConservationId(user.id)}/messages/')
        .snapshots();
  }

// chats (collection) --> conservation_id (doc) --> messages (collection) --> message (doc)

// for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send
    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: "",
        type: Type.text,
        sent: time,
        fromId: user.uid);

    // message to send
    final ref = firestore
        .collection('chats/${getConservationId(chatUser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }
}
