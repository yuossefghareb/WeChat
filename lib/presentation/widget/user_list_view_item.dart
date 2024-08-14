// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:chat1/core/app_router.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class UsersListViewItem extends StatefulWidget {
//   UsersListViewItem({super.key, required this.data});

//   Map<String, dynamic> data;

//   @override
//   State<UsersListViewItem> createState() => _UsersListViewItemState();
// }

// class _UsersListViewItemState extends State<UsersListViewItem> {
//   String urlimage =
//       'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

//   @override
// void initState() {
//   super.initState();
//   _loadImageUrl();
// }

// void _loadImageUrl() async {
//   urlimage = await getUrl();
//   setState(() {});
// }

// Future<String> getUrl() async {
//   var imagename = widget.data['image'];
//   if (imagename == "null"|| imagename == '') {
//     return 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
//   } else {
//     var refStorage = FirebaseStorage.instance.ref("UserImages/$imagename");
//     return await refStorage.getDownloadURL();
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(widget.data['name']),
//       subtitle: const Text("subTitle"),
//       leading: CircleAvatar(
//         backgroundImage: widget.data['image'] == null
//             ? NetworkImage(urlimage)
//             : NetworkImage(urlimage),
//       ),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () {
//         Navigator.pushNamed(context, Routes.chatPage, arguments: widget.data);
//       },
//     );
//   }
// }

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/core/my_date_util.dart';
import 'package:chat1/main.dart';
import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:chat1/presentation/views_model/model/message.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final bool? showAbout;

  const ChatUserCard({super.key, required this.user, this.showAbout = false});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            //for navigating to chat screen
            Navigator.pushNamed(context, Routes.chatPage,
                arguments: widget.user);
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];
              if (widget.user.id == APIs.user.uid) {
                return Container();
              }
              return ListTile(
                //user profile picture
                leading: InkWell(
                  onTap: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => ProfileDialog(user: widget.user));
                  },
                  child: ProfileImage(imagename: widget.user.image),
                ),

                //user name
                title: Text(widget.user.name),

                //last message
                subtitle: widget.showAbout == true
                    ? Text(widget.user.about)
                    : Text(
                        _message != null
                            ? _message!.type == Type.image
                                ? 'image'
                                : _message!.msg
                            : widget.user.about,
                        maxLines: 1),

                //last message time
                trailing: widget.showAbout == true
                    ? Text('')
                    : _message == null
                        ? null //show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != APIs.user.uid
                            ?
                            //show for unread message
                            const SizedBox(
                                width: 15,
                                height: 15,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 0, 230, 119),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                              )
                            :
                            //message sent time
                            Text(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: Colors.black54),
                              ),
              );
            },
          )),
    );
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.imagename,
    this.size = 23,
  });

  final String imagename;
  final double size;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String urlimage =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  void _loadImageUrl() async {
    urlimage = await getUrl();
    setState(() {});
  }

  Future<String> getUrl() async {
    var imagename = widget.imagename;
    if (imagename == "null" || imagename == '') {
      return 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    } else {
      var refStorage = FirebaseStorage.instance.ref("UserImages/$imagename");
      return await refStorage.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.size.toDouble(),
      backgroundImage: NetworkImage(urlimage),
    );
  }
}
