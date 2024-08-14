import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {super.key,
      required this.title,
      required this.value,
      required this.onpressed,
      required this.iconData,
      this.isEdit = true});
  final String title;
  final String value;
  final VoidCallback onpressed;
  final IconData iconData;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isEdit == false
            ? const Text("")
            : IconButton(
                onPressed: onpressed,
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                value.length < 30
                    ? Text(value, style: TextStyle(fontSize: 16))
                    : Text(value.substring(0, 30),
                        style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(width: 20),
            Icon(iconData, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
