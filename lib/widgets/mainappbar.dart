import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    this.apptitle = '',
    this.bg = Colors.white,
    this.fg = Colors.black,
    this.center,
  }) : super(
            title: Text(apptitle!),
            backgroundColor: bg,
            foregroundColor: fg,
            elevation: 0,
            centerTitle: center);
  final String? apptitle;
  final Color? bg;
  final Color? fg;
  final bool? center;
}
