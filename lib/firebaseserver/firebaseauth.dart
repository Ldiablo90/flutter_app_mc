import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:maccave/models/loginmodel.dart';

class CustomAuth {
  static final db = FirebaseFirestore.instance;
  static final userColection = db.collection('users');
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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
    bool signInGoogleInstance = false;
    print('signInGoogle');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return LoginModel(type: signInGoogleInstance, messege: '구글로그인 취소');
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
        return LoginModel(type: signInGoogleInstance, messege: '');
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
      signInGoogleInstance = true;
      return LoginModel(type: signInGoogleInstance, messege: '');
    } on PlatformException catch (platFormErr) {
      print(platFormErr.code);
      print(platFormErr.toString());
      return LoginModel(type: signInGoogleInstance, messege: '');
    } on FirebaseAuthException catch (fireErr) {
      print(fireErr.code);
      print(fireErr.toString());
      return LoginModel(type: signInGoogleInstance, messege: '');
    } catch (e) {
      print('orders erro');
      print(e);
      return LoginModel(type: false, messege: '');
    }
  }

  static Future<LoginModel> signOut() async {
    print('signOut 버튼');
    bool signOutInstance = false;

    try {
      _auth.signOut().then((value) {
        GoogleSignIn().signOut();
        signOutInstance = true;
      });
      return LoginModel(type: signOutInstance, messege: '로그아웃 성공');
    } catch (_) {
      print('구글 로그아웃 에러');
    }
    return LoginModel(type: signOutInstance, messege: '');
  }

  static Future<LoginModel> signInKakao() async {
    print('signInKakao');
    bool signInKakaoInstance = false;

    return LoginModel(type: signInKakaoInstance, messege: '구현중입니다.');
  }

  static Future<LoginModel> signInNaver() async {
    print('signInNaver()');
    bool signInNaverInstance = false;

    return LoginModel(type: signInNaverInstance, messege: '구현중입니다.');
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
}
