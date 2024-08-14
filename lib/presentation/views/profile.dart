import 'package:chat1/presentation/views_model/profile_cubit/profile_cubit.dart';
import 'package:chat1/presentation/widget/profile_body.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Profile')),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit()..getData(),
        child: const ProfilePageBody(),
      ),
    );
  }
}
