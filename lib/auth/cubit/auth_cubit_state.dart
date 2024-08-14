part of 'auth_cubit_cubit.dart';

@immutable
sealed class AuthCubitState {}

final class AuthCubitInitial extends AuthCubitState {}

final class AddUserLoading extends AuthCubitState {}
final class AddUserSuccess extends AuthCubitState {
  final UserCredential user;

  AddUserSuccess(this.user);
}

final class AddUserError extends AuthCubitState {
  final String error;
  AddUserError(this.error);
}

final class LoginUserLoading extends AuthCubitState {}

final class LoginUserSuccess extends AuthCubitState {
  final UserCredential user;

  LoginUserSuccess(this.user);
}

final class LoginUserError extends AuthCubitState {
  final String error;
  LoginUserError(this.error);
}