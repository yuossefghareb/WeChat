import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/colors.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:chat1/presentation/widget/user_list_view_item.dart';

import 'package:flutter/material.dart';

class AllUserPage extends StatefulWidget {
  const AllUserPage({super.key});

  @override
  State<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Users',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.backgroundColor,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          searchWidget(),
          Flexible(
            child: StreamBuilder(
                stream: APIs.getAllUserInApp(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];
                      final length = data?.length;
                      if (length == 0) {
                        return const Center(
                          child: Text('No Users'),
                        );
                      }
                      return ListView.builder(
                        itemCount:
                            _searchList.isEmpty ? length : _searchList.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _searchList.isNotEmpty
                                  ? _searchList[index]
                                  : _list[index],
                              showAbout: true);
                        },
                      );
                  }
                }),
          ),
        ],
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
