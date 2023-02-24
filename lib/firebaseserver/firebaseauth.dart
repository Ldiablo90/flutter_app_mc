import 'dart:io';
import 'dart:convert' as convert;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:maccave/firebaseserver/firebaseauthremotedatasource.dart';
import 'package:maccave/models/loginmodel.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class CustomAuth {
  static final db = FirebaseFirestore.instance;
  static final userColection = db.collection('users');
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final customToken = FirebaseAuthRemoteDataSorce();

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

  static Future<LoginModel> signInGoogle() async {
    print('signInGoogle');
    bool signInInstance = false;
    String messege = "구현중입니다.";
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        messege = '구글로그인 취소';
        return LoginModel(type: signInInstance, messege: messege);
      }
      // Obtain the auth details from the request
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final googleInfo = await _auth.signInWithCredential(credential);

      if (googleInfo.user == null) {
        return LoginModel(type: signInInstance, messege: '');
      }
      final querySnapshot = await userColection
          .where('email', isEqualTo: googleInfo.user!.email)
          .get();
      if (querySnapshot.docs.isEmpty) {
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
      return LoginModel(type: signInInstance, messege: messege);
    } on PlatformException catch (platFormErr) {
      print('PlatformException');
      print(platFormErr.code);
      messege = "관리자에게 문의 부탁드립니다.\n(plat)";
      return LoginModel(type: signInInstance, messege: messege);
    } on FirebaseAuthException catch (fireErr) {
      print(fireErr.code);
      messege = "관리자에게 문의 부탁드립니다.\n(fire)";
      return LoginModel(type: signInInstance, messege: messege);
    } catch (e) {
      print('orders erro');
      print(e);
      messege = "관리자에게 문의 부탁드립니다.\n(order)";
      return LoginModel(type: signInInstance, messege: messege);
    }
  }

  static Future<LoginModel> signOut() async {
    print('signOut 버튼');
    bool signOutInstance = false;
    String messege = "구현중입니다.";
    try {
      _auth.signOut().then((value) {
        GoogleSignIn().signOut();
        signOutInstance = true;
        messege = "로그아웃 성공";
      });
      return LoginModel(type: signOutInstance, messege: messege);
    } catch (_) {
      print('구글 로그아웃 에러');
    }
    return LoginModel(type: signOutInstance, messege: '');
  }

  static Future<LoginModel> signInKakao() async {
    print('signInKakao');
    bool signInInstance = false;
    String messege = "구현중입니다.";
    // 카카오 앱으로 로그인
    final isInstalled = await isKakaoTalkInstalled();

    try {
      final OAuthToken oAuthToken = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
      final user = await UserApi.instance.me();
      print(user);
      final stateToken = {
        'uid': user.id.toString(),
        'displayName': user.properties!['nickname'],
        'email': user.kakaoAccount!.email
      };
      print(stateToken);
      final userCredential =
          await _auth.signInWithCustomToken(stateToken.toString());

      // final kakaoToken = await UserApi.instance.loginWithKakaoTalk();
      // await _auth.signInWithCustomToken('');
      // print(await UserApi.instance.me());
      // print(kakaoToken.toString());
      // print(token);
      // if(userCredential.user == null){}
      print('카카로 로그인 성공');
      // signInInstance = true;
      messege = "카카오로 로그인 되었습니다.";
    } on KakaoAuthException catch (error) {
      if (error.error == AuthErrorCause.misconfigured) {
        messege = "카카오 등록 에러";
      }
      print(error.message);
      return LoginModel(type: signInInstance, messege: messege);
    } on PlatformException catch (error) {
      // 뒤로가기 혹은 로그인 취소 시
      if (error.code == "CANCELED") {
        print('사용자가 로그인을 취소하였습니다.');
        messege = "카카오 로그인 취소";
      }
      return LoginModel(type: signInInstance, messege: messege);
    } on FirebaseAuthException catch (error) {
      print('파이어베이스 auth에러.');
      print(error);
      messege = "카카오 로그인 실패";
    } catch (error) {
      print('카카오톡 로그인 실패');
      print(error);
      try {
        final token = await UserApi.instance.loginWithKakaoAccount();
        print('true => loginWithKakaoAccount : 로그인성공');
      } catch (error) {
        print('true => loginWithKakaoAccount : 로그인실패');
        print(error);
      }
    }
    return LoginModel(type: signInInstance, messege: messege);
  }

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
    ;
  }

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
          "name": facebookInfo.user!.providerData[0].displayName,
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
}
