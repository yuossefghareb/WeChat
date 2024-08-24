import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final bool? obscure;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  final bool? cancel;

  const CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.validator,
      this.obscure,
      this.cancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: mycontroller,
        validator: validator,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 184, 184, 184))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey))),
      ),
    );
  }
}
