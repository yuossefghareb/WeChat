import 'package:chat1/auth/cubit/auth_cubit_cubit.dart';
import 'package:chat1/auth/firebase_auth.dart';
import 'package:chat1/auth/login.dart';
import 'package:chat1/auth/register.dart';
import 'package:chat1/core/api/apis.dart';
import 'package:chat1/presentation/views/all_user_page.dart';
import 'package:chat1/presentation/views/chat_page.dart';
import 'package:chat1/presentation/views/home.dart';
import 'package:chat1/presentation/views/profile.dart';
import 'package:chat1/presentation/views/profile_edit_page.dart';
import 'package:chat1/presentation/views/splash_page.dart';

import 'package:chat1/presentation/views_model/model/chat_user.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubitCubit(Auth()),
            child: const RegisterPage(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubitCubit(Auth()),
            child: const LoginPage(),
          ),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case Routes.allUser:
        return MaterialPageRoute(
          builder: (_) => const AllUserPage(),
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        );
      case Routes.chatPage:
        var user = settings.arguments as ChatUser;
        return MaterialPageRoute(
          builder: (_) => ChatPage(
            user: user,
          ),
        );

      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case Routes.profileEdit:
        var user = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProfileEditPage(
            title: user['title'],
            value: user['value'],
            userid: user['userid'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String register = '/register';
  static const String profile = '/profile';

  static const String chatPage = '/chatPage';

  static const String allUser = '/allUser';
  static const String splash = '/splash';
  static const String profileEdit = '/profileEdit';
}
