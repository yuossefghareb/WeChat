import 'package:bloc/bloc.dart';
import 'package:chat1/auth/firebase_auth.dart';
import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit(this._auth) : super(AuthCubitInitial());

  final Auth _auth;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(
      {required String email,
      required String password,
      required String name}) async {
    emit(AddUserLoading());
    try {
      final authResult = await _auth.signUp(email, password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      //
      await APIs.createUser().then((value) {
        print('=========user created====================================');
      });

      emit(AddUserSuccess(authResult));
    } catch (e) {
      print('===========================$e============================');
      emit(AddUserError(e.toString()));
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginUserLoading());
    try {
      final authResult = await _auth.signin(email, password);

      emit(LoginUserSuccess(authResult));
    } catch (e) {
      print('===========================$e============================');
      emit(LoginUserError(e.toString()));
    }
  }
}
