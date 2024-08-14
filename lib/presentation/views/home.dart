import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';

import 'package:chat1/presentation/views_model/user/user_cubit.dart';
import 'package:chat1/presentation/widget/user_list_view_item.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Chat')),
        leading: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.profile);
              },
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      BlocProvider.of<UserCubit>(context).imageprofile,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.allUser);
        },
        child: const Icon(Icons.chat),
      ),
      body: StreamBuilder(
          stream: APIs.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                
                return StreamBuilder(
                  stream: APIs.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final users = snapshot.data!.docs
                              .map((e) => ChatUser.fromJson(e.data()))
                              .toList();

                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                user: users[index],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('No users'),
                          );
                        }
                    }
                  },
                );
            }
          }),
    );
  }
}
