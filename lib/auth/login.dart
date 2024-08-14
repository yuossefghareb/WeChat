import 'package:chat1/auth/cubit/auth_cubit_cubit.dart';
import 'package:chat1/core/app_router.dart';
import 'package:chat1/core/widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerPass = TextEditingController();
  final TextEditingController controllerUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/Frame.png",
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: ListView(
                  children: [
                    Container(
                      height: 220,
                    ),
                    const Text(
                      "Login to in your account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "email",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CustomTextForm(
                      cancel: true,
                      hinttext: 'Enter User Name',
                      mycontroller: controllerUser,
                      validator: (validator) {
                        if (validator == "") {
                          return 'username must not be empty';
                        }
                        return null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CustomTextForm(
                      hinttext: "ُEnter Your Password",
                      mycontroller: controllerPass,
                      validator: (value) {
                        if (value == "") {
                          return 'password must not be empty';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.abc),
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ),
                    BlocListener<AuthCubitCubit, AuthCubitState>(
                      listener: (context, state) {
                        if (state is LoginUserSuccess) {
                          print('success');
                          Navigator.pushReplacementNamed(context, Routes.home,
                              arguments: state.user);
                        } else {
                          print('error');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            height: 40,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () {
                              context.read<AuthCubitCubit>().loginUser(
                                  email: controllerUser.text,
                                  password: controllerPass.text);
                            },
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.register);
                            },
                            child: const Text('Register'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
