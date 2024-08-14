import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat1/core/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  String imageprofile =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  String name = '';
  String email = '';
  String about = '';

  getImage() async {
    try {
      emit(ProfileLoading());
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .get();
      var inagename = documentSnapshot['image'];

      if (inagename == "null" || inagename == '') {
        imageprofile =
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
      } else {
        imageprofile = await FirebaseStorage.instance
            .ref("UserImages/$inagename")
            .getDownloadURL();
      }

      print(imageprofile);
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  getData() async {
    try {
      emit(ProfileLoading());
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .get();
      name = documentSnapshot['name'];
      email = documentSnapshot['email'];
      about = documentSnapshot['about'];
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  updateImage(String imagename, File file) async {
    emit(ProfileLoading());
    try {
      var refStorage = FirebaseStorage.instance.ref("UserImages/$imagename");

      await refStorage.putFile(file);
       //!  if exit image in path delete it   
       ////?pending
      // var delete = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(CacheHelper.getData(key: 'doc_id'))
      //     .get();
          
      //   var refStorage1 = FirebaseStorage.instance.ref("UserImages/$delete");
      //   await refStorage1.delete();
       //  
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .update({'image': imagename});
      imageprofile = await refStorage.getDownloadURL();

      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  updateName(String name) async {
    emit(ProfileLoading());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .update({'name': name});
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  updateAbout(String about) async {
    emit(ProfileLoading());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'doc_id'))
          .update({'about': about});
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
