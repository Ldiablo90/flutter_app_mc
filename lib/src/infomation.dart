import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/usermodel.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/widgets/policyandquestion.dart';
import 'package:maccave/widgets/userprofile.dart';

class UserInFoScreen extends StatefulWidget {
  const UserInFoScreen({Key? key}) : super(key: key);

  @override
  State<UserInFoScreen> createState() => _UserInFoScreenState();
}

class _UserInFoScreenState extends State<UserInFoScreen> {
  late UserModel user;
  bool loadding = true;

  Future<void> setUser() async {
    user = await FireStoreData.getUser();
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '마이 페이지', center: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !loadding
                ? Column(
                    children: [
                      UserProfile(user: user),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: PolicyAndQustion()),
                    ],
                  )
                : LoadingPage(height: 200),
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // MacCaveElevatedButton(
                  //   child: const Text('회원탈퇴'),
                  //   onPressed: () {
                  //     CustomAuth.withdrawal().then((model) {
                  //       if (model.type) {
                  //         context.go('/');
                  //       } else {
                  //         showDialog(
                  //           context: context,
                  //           barrierDismissible: true,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               content: Text(model.messege),
                  //             );
                  //           },
                  //         ).then(
                  //           (value) => {if (model.type) {}},
                  //         );
                  //       }
                  //     });
                  //   },
                  // ),
                  // const SizedBox(width: 10),
                  // MacCaveElevatedButton(
                  //   onPressed: () {
                  //     CustomAuth.signOut().then((model) {
                  //       if (model.type) {
                  //         context.go('/');
                  //       } else {
                  //         showDialog(
                  //           context: context,
                  //           barrierDismissible: true,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               content: Text(model.messege),
                  //             );
                  //           },
                  //         ).then(
                  //           (value) => {if (model.type) {}},
                  //         );
                  //       }
                  //     });
                  //   },
                  //   child: const Text('로그아웃'),
                  // ),
                  InkWell(
                    child: const Text('회원탈퇴'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(""),
                            actions: [
                              MacCaveElevatedButton(child: const Text('확인')),
                            ],
                          );
                        },
                      );
                      // CustomAuth.withdrawal().then((model) {
                      //   if (model.type) {
                      //     context.go('/');
                      //   } else {
                      //     showDialog(
                      //       context: context,
                      //       barrierDismissible: true,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           content: Text(model.messege),
                      //         );
                      //       },
                      //     ).then(
                      //       (value) => {if (model.type) {}},
                      //     );
                      //   }
                      // });
                    },
                  ),
                  InkWell(
                    child: const Text('로그아웃'),
                    onTap: () {
                      CustomAuth.signOut().then((model) {
                        if (model.type) {
                          context.go('/');
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(model.messege),
                              );
                            },
                          ).then(
                            (value) => {if (model.type) {}},
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
