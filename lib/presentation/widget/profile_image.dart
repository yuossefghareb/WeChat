import 'package:chat1/core/api/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.userid,
    this.size = 25,
  });

  final String userid;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: APIs.getProfileImage(userid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while the stream is loading
          }
          if (snapshot.hasError) {
            return const Icon(Icons.error,
                size: 50); // Show an error icon if there's an error
          }
          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              snapshot.data!['image'] == 'null') {
            return CircleAvatar(
              radius: size.toDouble(),
              backgroundImage:
                  const NetworkImage("https://i.stack.imgur.com/l60Hf.png"),
            );
          }
          return CircleAvatar(
            radius: size.toDouble(),
            backgroundImage: NetworkImage(snapshot.data!['image']),
          );
        });
  }
}
