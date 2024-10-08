import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/core/colors.dart';

import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:chat1/presentation/widget/favourite_list_view.dart';
import 'package:chat1/presentation/widget/favourite_user_item.dart';

import 'package:chat1/presentation/widget/user_list_view_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const AppBarWidget(),
              const SizedBox(
                height: 10,
              ),
              searchWidget(),
              const Padding(
                padding: EdgeInsets.only(left: 40, bottom: 10),
                child: Text(
                  'Favourite ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: FavouriteListView(),
              ),
              StreamBuilder(
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
                                  _list = snapshot.data!.docs
                                      .map((e) => ChatUser.fromJson(e.data()))
                                      .toList();

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _searchList.isNotEmpty
                                        ? _searchList.length
                                        : _list.length,
                                    itemBuilder: (context, index) {
                                      return ChatUserCard(
                                        user: _searchList.isNotEmpty
                                            ? _searchList[index]
                                            : _list[index],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
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
                  child: TextField(
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(66, 0, 0, 0),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      _searchList.clear();
                      value = value.toLowerCase();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(value) ||
                            i.email.toLowerCase().contains(value)) {
                          _searchList.add(i);
                        }
                      }
                      setState(() => _searchList);
                    },
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
                Navigator.pushNamed(context, Routes.profile,
                    arguments: APIs.me);
              },
              child: StreamBuilder<DocumentSnapshot>(
                stream: APIs.getProfileImage(APIs.user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading indicator while the stream is loading
                  }
                  if (snapshot.hasError) {
                    return const Icon(Icons.error,
                        size: 50); // Show an error icon if there's an error
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Icon(Icons.account_circle, size: 50);
                  }

                  String? imageUrl = snapshot.data!['image'];

                  return CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(imageUrl ?? ''),
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
