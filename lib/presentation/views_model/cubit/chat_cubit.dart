import 'package:bloc/bloc.dart';
import 'package:chat1/core/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List data = [];
  getAllMessages() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .collection('messages')
          .get();
        data.addAll(querySnapshot.docs);
      emit(AllMessagesSuccess(data));
    } catch (e) {
      emit(AllMessagesError(e.toString()));
    }
  }
}
