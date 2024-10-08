import 'dart:developer';
import 'dart:io';

import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:chat1/presentation/views_model/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class APIs {
  // for authentication
//sdd//
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  // to return current user
  static User get user => auth.currentUser!;
  // for storing self information
  static ChatUser me = ChatUser(
    id: user.uid,
    name: user.displayName.toString(),
    email: user.email.toString(),
    about: "Hey, I'm using We Chat!",
    image: user.photoURL.toString(),
    createdAt: '',
    isOnline: false,
    lastActive: '',
    pushToken: '',
  );

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name, //our name should be send
            "body": msg,
          },
        }
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'we-chat-75f13';

      // get firebase admin token
      // final bearerToken = await NotificationAccessToken.getToken;

      // log('bearerToken: $bearerToken');

      // // handle null token
      // if (bearerToken == null) return;

      // var res = await post(
      //   Uri.parse(
      //       'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
      //   headers: {
      //     HttpHeaders.contentTypeHeader: 'application/json',
      //     HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
      //   },
      //   body: jsonEncode(body),
      // );

      // log('Response status: ${res.statusCode}');
      // log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({
            'isFavourite': true,
          });

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFavouriteUsers() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .where('isFavourite', isEqualTo: true)
        .snapshots();
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

//@yuossefghareb

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserInApp() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: me.id)
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        //because empty list throws an error') //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    print("first mseess-===================");
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo(
      String userId, String? name, String? about) async {
    if (name != null) {
      await firestore.collection('users').doc(userId).update({
        'name': name,
      }).then((value) => getSelfInfo());
    } else {
      await firestore.collection('users').doc(userId).update({
        'about': about,
      }).then((value) => getSelfInfo());
    }

    if (userId == user.uid) {
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(name ?? me.name);
    }
  }

  // update profile picture of user
  static Future<String?> updateProfileImage(XFile image, String userId) async {
    try {
      // Create a reference to Firebase Storage
      // Step 1: Get the old profile image URL
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String? oldImageUrl = userDoc['image'];

      // Step 2: Delete the old image from Firebase Storage if it exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          // Extract the reference path from the URL
          Reference oldImageRef =
              FirebaseStorage.instance.refFromURL(oldImageUrl);
          await oldImageRef.delete();
          print('Old image deleted successfully.');
        } catch (e) {
          print('Error deleting old image: $e');
        }
      }

      // Step 3: Upload the new image
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String newImageUrl = await taskSnapshot.ref.getDownloadURL();

      // Step 4: Update the Firestore document with the new image URL
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'image': newImageUrl,
      });

      print('New image uploaded and Firestore updated.');
      return newImageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return "";
    }
  }

  static Future<void> saveProfileImageUrl(String imageUrl, String userId) async {
    //! and here
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'image': imageUrl,
      });

      print('Image URL saved successfully');
    } catch (e) {
      print('Error saving image URL: $e');
    }
  }
  //

  static Stream<DocumentSnapshot> getProfileImage(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
