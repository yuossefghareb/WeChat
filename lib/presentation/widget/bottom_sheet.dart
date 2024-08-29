import 'dart:io';

import 'package:chat1/core/api/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages


void bottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext ctx) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 40),
        height: 190,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {}
                  },
                  icon: const Icon(Icons.camera_alt,
                      size: 38, color: Colors.blue),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("الكاميرة", style: TextStyle(fontSize: 18)),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                     
                      //  var imagename = basename(pickedFile.path);
                      Navigator.of(context).pop();
                      final imageUrl =
                          await uploadImage(pickedFile, APIs.user.uid);
                        await  saveProfileImageUrl(imageUrl!);
                    }
                  },
                  icon: const Icon(
                    Icons.photo,
                    size: 38,
                    color: Colors.blue,
                  ),
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.blueGrey),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("المعرض", style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<String?> uploadImage(XFile image, String userId) async {
  try {
    // Create a reference to Firebase Storage
    Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

    // Upload the file to the reference
    UploadTask uploadTask = storageRef.putFile(File(image.path));

    // Wait until the upload is complete
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    print('Download URL: $downloadURL');
    return downloadURL;
  } catch (e) {
    print('Error uploading image: $e');
    return "";
  }
}

Future<void> saveProfileImageUrl(String imageUrl) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(APIs.user.uid)
        .update({
      'image': imageUrl,
    });

    print('Image URL saved successfully');
  } catch (e) {
    print('Error saving image URL: $e');
  }
}
