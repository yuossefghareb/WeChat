import 'package:flutter/material.dart';

class CustomProfileEditName extends StatelessWidget {
  const CustomProfileEditName(
      {super.key,
      required this.title,
      required this.name,
      required this.onPressed});
  final String title;
  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.blue)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 12)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    const Icon(Icons.person, color: Colors.blue, size: 20),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              name,
              style: TextStyle(fontSize: 12),
              textDirection: TextDirection.rtl,
            ),
          )
        ],
      ),
    );
  }
}
