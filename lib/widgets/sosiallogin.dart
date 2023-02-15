import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';

class SosialLoginWidget extends StatelessWidget {
  const SosialLoginWidget({Key? key}) : super(key: key);

  final double iconwidth = 200;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: iconwidth,
            child: InkWell(
              child: Image.asset(
                'assets/naverlogo.png',
                fit: BoxFit.cover,
              ),
              onTap: () {
                context.pushNamed('privacychack',
                    extra: CustomAuth.signInNaver);
              },
            ),
          ),
          SizedBox(
            width: iconwidth,
            child: InkWell(
              child: Image.asset(
                'assets/kakaologo.png',
                fit: BoxFit.cover,
              ),
              onTap: () {
                context.pushNamed('privacychack',
                    extra: CustomAuth.signInKakao);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            width: iconwidth,
            child: InkWell(
              child: Image.asset(
                'assets/googlelogo.png',
                fit: BoxFit.cover,
              ),
              onTap: () {
                context.pushNamed('privacychack',
                    extra: CustomAuth.signInGoogle);
              },
            ),
          ),
        ],
      ),
    );
  }
}
