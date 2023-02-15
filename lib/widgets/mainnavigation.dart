import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  DateTime? backbuttonpressedTime;
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final locationtemp = location.split('/')[1];
    final index = tabs.indexWhere(
        (e) => locationtemp.startsWith(e.initialLocation.split('/')[1]));
    return index < 0 ? 0 : index;
  }

  void _onItemTapped(BuildContext context, int tabIndex) {
    final locationtemp = GoRouter.of(context).location.split('/')[1];
    final selecttemp = tabs[tabIndex].initialLocation.split('/')[1];
    final int target;
    if (locationtemp.startsWith(selecttemp)) {
      target = tabIndex;
    } else {
      target = tabs.indexWhere(
          (e) => locationtemp.startsWith(e.initialLocation.split('/')[1]));
    }
    if (target > -1 && !GoRouter.of(context).location.contains('edit')) {
      setState(() {
        tabs[target] = MainNavigationItem(
            initialLocation: GoRouter.of(context).location,
            icon: tabs[target].icon,
            label: tabs[target].label);
      });
    }
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex].initialLocation);
    }
  }

  void userLoginStream() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        user == null ? context.go('/') : null;
      },
    );
  }

  final tabs = <MainNavigationItem>[
    const MainNavigationItem(
      initialLocation: '/feed',
      icon: Icon(Icons.home_filled),
      label: '피드',
    ),
    const MainNavigationItem(
      initialLocation: '/community',
      icon: Icon(Icons.forum_outlined),
      label: '커뮤니티',
    ),
    const MainNavigationItem(
      initialLocation: '/raffle',
      icon: Icon(Icons.assistant_outlined),
      label: 'RAFFLE',
    ),
    const MainNavigationItem(
      initialLocation: '/gallery',
      icon: Icon(Icons.collections),
      label: 'GALLERY',
    ),
    const MainNavigationItem(
      initialLocation: '/userinfo',
      icon: Icon(Icons.person),
      label: '마이페이지',
    ),
  ];

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
  void initState() {
    super.initState();
    userLoginStream();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey[600],
          selectedItemColor: Colors.white,
          items: tabs,
          onTap: (value) => _onItemTapped(context, value),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime currentTime = DateTime.now();

    // Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime!) >
            const Duration(seconds: 2);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "한번 더 뒤로가기 누르시면 엡 종료",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class MainNavigationItem extends BottomNavigationBarItem {
  const MainNavigationItem({
    required this.initialLocation,
    required Widget icon,
    String? label,
    Widget? acicon,
  }) : super(icon: icon, label: label, activeIcon: acicon);
  final String initialLocation;
}
