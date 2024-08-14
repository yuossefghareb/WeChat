import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.loadingWidth,
    this.width,
    this.height,
    this.errorIconSize,
  });
  final String imageUrl;
  final double? loadingWidth;
  final double? width;
  final double? height;
  final double? errorIconSize;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width ?? 110,
        height: height ?? 110,
        fit: BoxFit.contain,
        errorWidget: (context, url, error) {
          return Container(
            width: width ?? 110,
            height: height ?? 110,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(Icons.person,
                color: Colors.blue, size: errorIconSize ?? 40),
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
