import 'package:chat1/core/api/apis.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:chat1/presentation/widget/user_list_view_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AllUserPage extends StatefulWidget {
  const AllUserPage({super.key});

  @override
  State<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder(
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
                final length = data?.length;
                if (length == 0) {
                  return const Center(
                    child: Text('No Users'),
                  );
                }
                return ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    final json = data?[index].data();
                    final user = ChatUser.fromJson(json!);
                    return ChatUserCard(user: user, showAbout: true);
                  },
                );
            }
          }),
    );
  }
}
