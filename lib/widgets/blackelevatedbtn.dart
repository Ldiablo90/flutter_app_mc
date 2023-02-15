import 'package:flutter/material.dart';

class MacCaveElevatedButton extends ElevatedButton {
  MacCaveElevatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
  }) : super(
          onPressed: onPressed,
          child: child,
          style: ElevatedButton.styleFrom(
              backgroundColor: color != null ? color : Colors.black),
        );
  final Function()? onPressed;
  final Widget child;
  Color? color;
}
