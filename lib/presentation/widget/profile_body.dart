import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';

import 'package:chat1/presentation/widget/profile_item.dart';
import 'package:chat1/presentation/widget/profile_user_image.dart';

import 'package:flutter/material.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key, this.user});

  final ChatUser? user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 22),
              ProfileUserImage(
                iconSize: 45,
                right: 105,
                top: 80,
                cameraSize: 21,
                userid: user?.id ?? APIs.me.id,
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  ProfileItem(
                    title: "Name",
                    value: user?.name ?? APIs.me.name,
                    iconData: Icons.person,
                    onpressed: () {
                      Navigator.pushNamed(context, Routes.profileEdit,
                          arguments: {
                            "title": "Name",
                            "value": user?.name ?? APIs.me.name,
                            "userid": user?.id ?? APIs.me.id,
                            
                          });
                    },
                  ),
                  const SizedBox(height: 22),
                  ProfileItem(
                    title: "About",
                    value: user?.about ?? APIs.me.about,
                    iconData: Icons.info,
                    onpressed: () {
                      Navigator.pushNamed(context, Routes.profileEdit,
                          arguments: {
                            "title": "About",
                            "value": user?.about ?? APIs.me.about,
                            "userid": user?.id ?? APIs.me.id,
                           
                          });
                    },
                  ),
                  const SizedBox(height: 22),
                  ProfileItem(
                    title: "email",
                    value: user?.email ?? APIs.me.email,
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
