import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/core/colors.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';

import 'package:chat1/presentation/views_model/user/user_cubit.dart';
import 'package:chat1/presentation/widget/user_list_view_item.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: MyColors.primaryColor,
      //   title: Text(
      //     'My Chat',
      //     style:
      //         TextStyle(color: MyColors.textColor, fontWeight: FontWeight.bold),
      //   ),
      //   leading: Row(
      //     children: [
      //       const SizedBox(
      //         width: 20,
      //       ),
      //       InkWell(
      //         onTap: () {
      //           Navigator.pushNamed(context, Routes.profile);
      //         },
      //         child: BlocBuilder<UserCubit, UserState>(
      //           builder: (context, state) {
      //             return CircleAvatar(
      //               radius: 18,
      //               backgroundImage: NetworkImage(
      //                 BlocProvider.of<UserCubit>(context).imageprofile,
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         FirebaseAuth.instance.signOut();
      //         Navigator.pushReplacementNamed(context, Routes.login);
      //       },
      //       icon: const Icon(Icons.logout, color: Colors.white),
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.allUser);
        },
        backgroundColor: Colors.white,
        
        child: const Icon(
          Icons.chat,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const AppBarWidget(),
            const SizedBox(
              height: 10,
            ),
            const SearchWidget(),
            Flexible(
              child: StreamBuilder(
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
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),
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
                                    shrinkWrap: true,
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
            ),
          ],
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: const Color.fromARGB(66, 0, 0, 0),
                  height: 50,
                  child: const TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(66, 0, 0, 0),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 40,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.profile);
              },
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      BlocProvider.of<UserCubit>(context).imageprofile,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'My Chat',
              style: TextStyle(
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, Routes.login);
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}
