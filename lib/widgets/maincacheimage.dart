import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MainCacheImage extends CachedNetworkImage {
  MainCacheImage({super.key, required this.imageUrl})
      : super(
          fadeInDuration: const Duration(milliseconds: 200),
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) {
            if (progress.progress != null) {
              return const Text('Loaded ing...');
            }
            return const Icon(Icons.image);
          },
        );
  String imageUrl;
}
