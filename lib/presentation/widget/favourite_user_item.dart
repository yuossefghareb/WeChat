import 'package:chat1/presentation/views_model/model/chat_user.dart';
import 'package:flutter/material.dart';

class FavouriteUserItem extends StatelessWidget {
  const FavouriteUserItem({super.key, required this.chatUser});

  final ChatUser chatUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 5),
      child: Stack(
        children: [
          // Layer 1: Background Image (Bottom layer)
          Container(
            width: 95,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: NetworkImage(
                  //! if null checker
                  chatUser.image,
                ), // Replace with your image path
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
          ),
          // Layer 2: Gradient Overlay (Middle layer)
          Container(
            width: 95,
            height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  spreadRadius: 0,
                  blurRadius: 20,

                  offset: const Offset(20, 24), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF292F3F)
                      .withOpacity(0.0), // Color with 0% opacity at the top
                  const Color(0xFF292F3F).withOpacity(
                      0.8), // Same color with 80% opacity at the bottom
                ],
                stops: const [0.0, 1.0], // Defines the gradient stops
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    chatUser.name,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      height: 1,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Layer 3: Content (Top layer)
        ],
      ),
    );
  }
}
