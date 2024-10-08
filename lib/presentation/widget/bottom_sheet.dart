import 'package:chat1/core/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages

void bottomSheet(BuildContext context,String userid) {
  //!!!!!!!! and here
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
                    if (pickedFile != null) {
                      Navigator.of(context).pop();
                      //! and here
                      final imageUrl = await APIs.updateProfileImage(
                          pickedFile, userid);
                      await APIs.saveProfileImageUrl(imageUrl!, userid);
                    }
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
                      Navigator.of(context).pop();
                      //! and here
                      final imageUrl = await APIs.updateProfileImage(
                          pickedFile, userid);
                      await APIs.saveProfileImageUrl(imageUrl!, userid);
                    }
                  },
                  icon: const Icon(
                    Icons.photo,
                    size: 38,
                    color: Colors.blue,
                  ),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
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
