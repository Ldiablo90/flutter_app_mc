import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/widgets/sosiallogin.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[200],
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text(
                  '이메일 로그인',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const Divider(
              height: 20,
              endIndent: 0,
              color: Colors.black,
            ),
            const SosialLoginWidget(),
          ],
        ),
      ),
    );
  }
}
