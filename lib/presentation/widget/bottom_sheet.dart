import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'package:chat1/presentation/views_model/profile_cubit/profile_cubit.dart';

void bottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext ctx) {
      return BlocProvider(
        create: (context) => ProfileCubit(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 40),
          height: 190,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {}
                    },
                    icon: const Icon(Icons.camera_alt,
                        size: 38, color: Colors.blue),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("الكاميرة", style: TextStyle(fontSize: 18)),
                ],
              ),
              Column(
                children: [
                  BlocListener<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileSuccess) {
                        print('successupadte');
                      } else if (state is ProfileError) {
                        print('${state.error}  ----update');
                      }
                    },
                    child: IconButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          var file = File(pickedFile.path);
                          var imagename = basename(pickedFile.path);
                          Navigator.of(context).pop();

                          BlocProvider.of<ProfileCubit>(context)
                              .updateImage(imagename, file);
                        }
                      },
                      icon: const Icon(
                        Icons.photo,
                        size: 38,
                        color: Colors.blue,
                      ),
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.blueGrey),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("المعرض", style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
