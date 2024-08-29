import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Color? color;
  const CustomButtonAuth({super.key, this.onPressed, required this.title,this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: color??Colors.blue,
          textColor: Colors.white,
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}