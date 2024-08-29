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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                value.length < 30
                    ? Text(value, style: const TextStyle(fontSize: 16))
                    : Text(value.substring(0, 30),
                        style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(width: 20),
            Icon(iconData, color: Colors.blue),
          ],
        ),
      ],
    );
  }
}
