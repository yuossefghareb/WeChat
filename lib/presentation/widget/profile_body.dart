import 'package:chat1/presentation/views_model/profile_cubit/profile_cubit.dart';
import 'package:chat1/presentation/widget/profile_item.dart';
import 'package:chat1/presentation/widget/profile_user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      ProfileItem(
                        title: "Name",
                        value: BlocProvider.of<ProfileCubit>(context).name,
                        iconData: Icons.person,
                        onpressed: () {},
                      ),
                      const SizedBox(height: 22),
                      ProfileItem(
                        title: "about",
                        value: BlocProvider.of<ProfileCubit>(context).about,
                        iconData: Icons.info,
                        onpressed: () {},
                      ),
                      const SizedBox(height: 22),
                      ProfileItem(
                        title: "email",
                        value: BlocProvider.of<ProfileCubit>(context).email,
                        iconData: Icons.email,
                        isEdit: false,
                        onpressed: () {},
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
