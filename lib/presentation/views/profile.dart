import 'package:chat1/core/colors.dart';

import 'package:chat1/presentation/widget/profile_body.dart';

import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        title: const Center(child: Text('My Profile')),
      ),
      body: const ProfilePageBody(),
    );
  }
}
