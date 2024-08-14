import 'package:chat1/core/widgets/custom_cached_image.dart';
import 'package:chat1/presentation/views_model/profile_cubit/profile_cubit.dart';
import 'package:chat1/presentation/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUserImage extends StatefulWidget {
  const ProfileUserImage({
    super.key,
    required this.iconSize,
    required this.right,
    required this.top,
    required this.cameraSize,
    this.image,
    this.isEdit = true,
  });
  final double iconSize;
  final double right;
  final double top;
  final bool isEdit;
  final double cameraSize;
  final String? image;

  @override
  State<ProfileUserImage> createState() => _ProfileUserImageState();
}

class _ProfileUserImageState extends State<ProfileUserImage> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ProfileCubit>(context).getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return Container(
                width: 129,
                height: 129,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 177, 168, 168),
                  borderRadius: BorderRadius.circular(200),
                  border: widget.image != null
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: CustomCachedImage(
                  imageUrl: BlocProvider.of<ProfileCubit>(context).imageprofile,
                  width: 115,
                  height: 115,
                  errorIconSize: 60,
                ),
              );
            } else if (state is ProfileError) {
              return Text(state.error);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        if (widget.isEdit)
          Positioned(
            right: widget.right,
            top: widget.top,
            child: IconButton(
              onPressed: () {
                bottomSheet(context);
              },
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: widget.cameraSize,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
}
