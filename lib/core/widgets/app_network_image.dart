import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Cached network image with a shimmer placeholder for room photos.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.imageUrl, this.fit, this.width, this.height});

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(color: const Color(0xFFE0E0E0)),
      ),
      errorWidget: (_, _, _) => Container(
        color: const Color(0xFFE0E0E0),
        child: const Icon(Icons.hotel, color: Colors.grey),
      ),
    );
  }
}
