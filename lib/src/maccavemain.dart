import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';
import 'package:maccave/widgets/sosiallogin.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class MacCaveMainScreen extends StatefulWidget {
  const MacCaveMainScreen({Key? key}) : super(key: key);

  @override
  State<MacCaveMainScreen> createState() => _MacCaveMainScreenState();
}

class _MacCaveMainScreenState extends State<MacCaveMainScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    final status = await Permission.calendar.request();
    if (status.isDenied) {
      // 요청을 취소 하였을 때
      Fluttertoast.showToast(msg: '겔러리 사용에 동의하여 주세요');
      Future.delayed(const Duration(seconds: 2));
      exit(0);
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      // 취소되었는데 다시 묻지 않기 되었을 때 (안드, IOS)
      Fluttertoast.showToast(msg: '겔러리 사용에 동의하고 재시작해 주세요');
      await Future.delayed(const Duration(seconds: 2));
      openAppSettings();
      exit(0);
    } else if (status.isGranted || status.isLimited) {
      // 요청이 성공하였거나 제한적 동의가 이루어 진경우
      await Future.delayed(const Duration(seconds: 2));
      print('go!');
      FlutterNativeSplash.remove();
    } else {
      print('뭐 아무것도 아니냐?');
      await Future.delayed(const Duration(seconds: 2));
      print('go!');
      FlutterNativeSplash.remove();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext maincontext) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .55,
              child: Image.asset(
                'assets/maccavelogoblack.png',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                '맥케이브 어플로 로그인하고\n실시간 주류 발매정보를 얻으세요',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: const <Widget>[],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
            const Text('간편 로그인하기'),
            const SizedBox(height: 20),
            const SosialLoginWidget(),
          ],
        ),
      ),
    );
  }
}
