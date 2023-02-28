import 'dart:io';
import 'dart:convert' as convert;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:maccave/firebaseserver/firebaseauthremotedatasource.dart';
import 'package:maccave/models/loginmodel.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class CustomAuth {
  static final db = FirebaseFirestore.instance;
  static final userColection = db.collection('users');
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final customToken = FirebaseAuthRemoteDataSorce();

  /*
  이메일 API
  static Future<LoginModel> signInEmailAndPass(email, pass) async {
    print("사용안하는 펑션");
    print("use not funtion");
    print("signUpEmailAndPass");
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return LoginModel(type: true, messege: '로그인 완료');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('user-not-found and wrong-password');
        print(e.code);
        return LoginModel(type: false, messege: '이메일 혹은 패스워드를 확인해 주세요.');
      }
      return LoginModel(type: false, messege: '관리자 문의');
    } catch (e) {
      return LoginModel(type: false, messege: '관리자 문의');
    }
  }

  static Future<LoginModel> signUpEmailAndPass(email, pass) async {
    print("사용안하는 펑션");
    print("use not funtion");
    print("signUpEmailAndPass");
    try {
      final user = _auth.currentUser;
      final createdate = new DateTime.now();
      if (user == null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: pass);
        final userData = <String, dynamic>{
          "email": userCredential.user?.email,
          "createdate": createdate,
          "drinklikes": [],
          "gallerylikes": [],
          "mileage_points": 0,
          "image": '',
        };
        userColection.doc(userCredential.user?.uid).set(userData);
        return LoginModel(type: true, messege: '회원가입 성공');
      } else {
        return LoginModel(type: false, messege: '관리자에게 문의');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password' || e.code == 'email-already-in-use') {
        print('아이디 혹은 패스워드 실수');
        return LoginModel(type: false, messege: '이미 가입된 이메일입니다');
      }
    } catch (e) {
      return LoginModel(type: false, messege: '관리자에게 문의');
    }
    throw Error();
  }
  */

  // ##################### 구글 로그인 START #####################
  static Future<LoginModel> signInGoogle() async {
    bool signInInstance = false; // 결과
    String messege = "구현중입니다."; // 결과 메세지
    try {
      // 구글 로그인 창 뜨는 Func
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // 구글 로그인 취소 시
      if (googleUser == null) {
        messege = '구글 로그인 취소';
        return LoginModel(type: signInInstance, messege: messege);
      }
      // Obtain the auth details from the request
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // 파이어 베이스 Auth 등록
      final googleInfo = await _auth.signInWithCredential(credential);

      // 파이어 베이스 Auth 등록 에러시
      if (googleInfo.user == null) {
        return LoginModel(type: signInInstance, messege: '');
      }
      // 기존 유저있는지 확인 이메일로 확인
      final querySnapshot = await userColection
          .where('email', isEqualTo: googleInfo.user!.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // 기본 정보 등록
        final addData = <String, dynamic>{
          "email": "${googleInfo.user?.email}",
          "drinklikes": [],
          "gallerylikes": [],
          "mileage_points": 0,
          "name": googleInfo.user!.providerData[0].displayName,
          "image": '',
        };
        userColection.doc(googleInfo.user?.uid).set(addData);
      }
      signInInstance = true;
      messege = "구글 로그인 성공";
    } on PlatformException catch (platFormErr) {
      print(platFormErr.code);
      messege = "관리자에게 문의 부탁드립니다.\n(plat)";
    } on FirebaseAuthException catch (fireErr) {
      print(fireErr.code);
      messege = "관리자에게 문의 부탁드립니다.\n(fire)";
    } catch (e) {
      print(e);
      messege = "관리자에게 문의 부탁드립니다.\n(order)";
    }
    return LoginModel(type: signInInstance, messege: messege);
  }
  // ##################### 구글 로그인 END #####################

  // ##################### 카카오 로그인 START #####################
  static Future<LoginModel> signInKakao() async {
    print('signInKakao');
    final _firebaseAuthRemoteDataSorce = FirebaseAuthRemoteDataSorce();
    bool signInInstance = false;
    String messege = "구현중입니다.";
    kakao.User? user;
    // 카카오 앱으로 로그인 가능?
    final isInstalled = await kakao.isKakaoTalkInstalled();

    try {
      // 엡 VS 웹
      final oAuthToken = isInstalled
          ? await kakao.UserApi.instance.loginWithKakaoTalk()
          : await kakao.UserApi.instance.loginWithKakaoAccount();
      // 유저 기본정보 읽기
      user = await kakao.UserApi.instance.me();
      // 그냥 파이어베이스에 유저 생성하고 토큰 받을 뿐인데 굳이 펑션까지 써야되는지 모르겠다....
      // 바로 그냥 유저 추가할수 있는 방법 없나...?createUserWithEmailAndPassword 같은?
      final token = await _firebaseAuthRemoteDataSorce.createCustomToken({
        'uid': user.id.toString(),
        'displayName': user.kakaoAccount!.profile!.nickname,
        'email': user.kakaoAccount!.email
      });
      // 가져온 토큰(사용자 정보가 들어있다)으로 auth 등록
      final userCredential = await _auth.signInWithCustomToken(token);

      if (userCredential.user == null) {
        messege = "로그인 실패";
        return LoginModel(type: signInInstance, messege: messege);
      }
      final querySnapshot = await userColection
          .where('email', isEqualTo: userCredential.user!.email)
          .get();
      if (querySnapshot.docs.isEmpty) {
        final addData = <String, dynamic>{
          "email": "${userCredential.user!.email}",
          "drinklikes": [],
          "gallerylikes": [],
          "mileage_points": 0,
          "name": userCredential.user!.displayName,
          "image": '',
        };
        userColection.doc(userCredential.user?.uid).set(addData);
      }

      print('카카로 로그인 성공');
      signInInstance = true;
      messege = "카카오로 로그인 되었습니다.";
    } on kakao.KakaoAuthException catch (error) {
      if (error.error == kakao.AuthErrorCause.misconfigured) {
        messege = "카카오 등록 에러";
      }
      print(error.message);
    } on PlatformException catch (error) {
      // 뒤로가기 혹은 로그인 취소 시
      if (error.code == "CANCELED") {
        print('사용자가 로그인을 취소하였습니다.');
        messege = "카카오 로그인 취소";
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      messege = "카카오 로그인 실패";
    } catch (error) {
      messege = "카카오 로그인 실패";
      print(error);
    }
    return LoginModel(type: signInInstance, messege: messege);
  }
  // ##################### 카카오 로그인 END #####################

  // ##################### 네이버 로그인 START #####################
  static Future<LoginModel> signInNaver() async {
    print('signInNaver()');
    bool signInInstance = false;
    String messege = "구현중입니다.";

    try {
      final NaverLoginResult naverLoginResult = await FlutterNaverLogin.logIn();
      final token = await FlutterNaverLogin.currentAccessToken;
      signInInstance = true;
      messege = "네이버 로그인 성공";
    } on PlatformException catch (error) {
    } on FirebaseAuthException catch (error) {
    } catch (e) {}
    return LoginModel(type: signInInstance, messege: messege);
  }

  static Future<LoginModel> withdrawal() async {
    bool withdrawlInstance = false;

    await userColection
        .doc(_auth.currentUser!.uid)
        .set({"delete_date": DateTime.now()});
    await _auth.currentUser!.delete().then((value) => withdrawlInstance = true);
    return LoginModel(type: withdrawlInstance, messege: '구현중입니다.');
  }
  // ##################### 네이버 로그인 END #####################

  static Future<LoginModel> signInFacebook() async {
    bool signInInstance = false;
    String messege = "구현중입니다.";
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final facebookInfo =
          await _auth.signInWithCredential(facebookAuthCredential);

      if (facebookInfo.user == null) {
        messege = "";
        return LoginModel(type: signInInstance, messege: messege);
      }
      final querySnapshot = await userColection
          .where('email', isEqualTo: facebookInfo.user!.email)
          .get();
      if (querySnapshot.docs.isEmpty) {
        final addData = <String, dynamic>{
          "email": "${facebookInfo.user?.email}",
          "drinklikes": [],
          "gallerylikes": [],
          "mileage_points": 0,
          "name": facebookInfo.user!.displayName,
          "image": '',
        };
        userColection.doc(facebookInfo.user?.uid).set(addData);
        signInInstance = true;
        messege = "페이스북 로그인 되었습니다.";
      }
    } catch (error) {
      print(error);
      messege = "페이스북 연결에 실패하였습니다.";
    }
    return LoginModel(type: signInInstance, messege: messege);
  }

  static Future<LoginModel> signOut() async {
    print('signOut 버튼');
    bool signOutInstance = false;
    String messege = "구현중입니다.";
    try {
      _auth.signOut().then((_) {
        GoogleSignIn().signOut();
        kakao.UserApi.instance.logout();
        signOutInstance = true;
        messege = "로그아웃 성공";
      });
    } catch (e) {
      messege = "로그아웃 에러";
      print(e.toString());
      print('로그아웃 에러');
    }
    return LoginModel(type: signOutInstance, messege: messege);
  }
}
