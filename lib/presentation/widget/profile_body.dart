import 'package:chat1/core/api/apis.dart';

import 'package:chat1/presentation/widget/profile_item.dart';
import 'package:chat1/presentation/widget/profile_user_image.dart';
import 'package:flutter/material.dart';


class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 22),
              const ProfileUserImage(
                iconSize: 45,
                right: 105,
                top: 80,
                cameraSize: 21,
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ProfileItem(
                    title: "Name",
                    value: APIs.me.name,
                    iconData: Icons.person,
                    onpressed: () {},
                  ),
                  const SizedBox(height: 22),
                  ProfileItem(
                    title: "about",
                    value: APIs.me.about,
                    iconData: Icons.info,
                    onpressed: () {},
                  ),
                  const SizedBox(height: 22),
                  ProfileItem(
                    title: "email",
                    value: APIs.me.email,
                    iconData: Icons.email,
                    isEdit: false,
                    onpressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
