

import 'package:bloc/bloc.dart';
import 'package:chat1/core/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  List data = [];

  String imageprofile =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  Future<void> getAllUsers() async {
    emit(UserLoading());
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      data.addAll(querySnapshot.docs);
      print("====================${data.length}===============");

      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: CacheHelper.getData(key: 'doc_id'))
          .get();
      var imagename = querySnapshot1.docs[0]['image'];

      if(imagename == "null"|| imagename == '') {
        imageprofile =
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
      } else {
        imageprofile = await FirebaseStorage.instance
            .ref("UserImages/$imagename")
            .getDownloadURL();
      }

      emit(UserSuccess(data));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // Future<void> updateImage(String image) async {
  //   emit(UserLoading());
  //   try {
  //     var refStorage = FirebaseStorage.instance.ref("UserImages/$image");

  //     imageprofile = await refStorage.getDownloadURL();
  //     emit(UserSuccess(data));
  //     print("sucess---------------------------------------");
  //   } catch (e) {
  //     emit(UserError(e.toString()));
  //   }
  // }
}
