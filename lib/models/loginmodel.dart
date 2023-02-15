import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  final bool type;
  final String messege;

  LoginModel({
    required this.type,
    required this.messege,
  });
}
