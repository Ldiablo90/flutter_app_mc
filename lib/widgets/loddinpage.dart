import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({Key? key, required this.height}) : super(key: key);
  double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
