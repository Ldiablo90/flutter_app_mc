import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GalleryImageWrapper extends Container {
  GalleryImageWrapper({
    super.key,
    required this.child,
    this.width,
    this.height,
  }) : super(
          child: child,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ],
          ),
        );
  Widget child;
  double? width;
  double? height;
}
