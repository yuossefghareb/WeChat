import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/widgets/custom_cached_image.dart';

import 'package:chat1/presentation/widget/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProfileUserImage extends StatefulWidget {
  const ProfileUserImage({
    super.key,
    required this.iconSize,
    required this.right,
    required this.top,
    required this.cameraSize,
    this.image,
    this.isEdit = true,
  });
  final double iconSize;
  final double right;
  final double top;
  final bool isEdit;
  final double cameraSize;
  final String? image;

  @override
  State<ProfileUserImage> createState() => _ProfileUserImageState();
}

class _ProfileUserImageState extends State<ProfileUserImage> {
  
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: getProfileImageStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Icon(Icons.account_circle, size: 50);
            }
            return Container(
              width: 129,
              height: 129,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 177, 168, 168),
                borderRadius: BorderRadius.circular(200),
                border: widget.image != null
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: CustomCachedImage(
                imageUrl: snapshot.data!['image'],
                width: 115,
                height: 115,
                errorIconSize: 60,
              ),
            );
          },
        ),
        if (widget.isEdit)
          Positioned(
            right: widget.right,
            top: widget.top,
            child: IconButton(
              onPressed: () {
                bottomSheet(context);
              },
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: widget.cameraSize,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  Stream<DocumentSnapshot> getProfileImageStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(APIs.user.uid)
        .snapshots();
  }
}
