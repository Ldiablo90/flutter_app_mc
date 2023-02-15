import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/cummunitymodel.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/comment.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class CummunityReading extends StatefulWidget {
  const CummunityReading({super.key, required this.id});
  final String id;
  @override
  State<CummunityReading> createState() => _CummunityReadingState();
}

class _CummunityReadingState extends State<CummunityReading> {
  bool cummunityOrner = false;
  late CummunityModel cummunity;
  bool loading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String dateChange(DateTime createdate) {
    final result = DateFormat('yyyy.MM.dd HH:mm').format(createdate);
    return result;
  }

  Future<void> setCummunity() async {
    final temp = await FireStoreData.getCummunity(widget.id);
    if (temp != null) {
      if (temp.userid == _auth.currentUser!.uid) {
        cummunityOrner = true;
      }
      cummunity = temp;
      loading = false;
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              '삭제된 컨텐츠 입니다.',
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('되돌아가기'),
              ),
            ],
          );
        },
      ).then((value) => context.pop());
    }
  }

  @override
  void initState() {
    super.initState();
    setCummunity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: ''),
      body: !loading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        cummunity.type,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cummunity.title,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: FireStoreData.getUser(id: cummunity.userid),
                    builder: (context, usersnapshot) {
                      if (usersnapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                            usersnapshot.data!.image),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(usersnapshot.data!.name),
                                  ],
                                ),
                              ),
                              Text(dateChange(cummunity.createdate)),
                            ],
                          ),
                        );
                      }
                      return LoadingPage(height: 50);
                    },
                  ),
                  Row(
                    children: [Text(cummunity.content)],
                  ),
                  cummunityOrner
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MacCaveElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text('게시물을 수정하시겠습니까?'),
                                      actions: [
                                        InkWell(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Text('취소'),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            context.pop();
                                            context.pushNamed('cummunityeidt',
                                                params: {"id": cummunity.id});
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Text('수정하기'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('수정하기'),
                            ),
                            const SizedBox(width: 10),
                            MacCaveElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            content:
                                                const Text('게시물을 삭제하시겠습니까?'),
                                            actions: [
                                              InkWell(
                                                onTap: () {
                                                  context.pop();
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  child: Text('취소'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FireStoreData.removeCummunity(
                                                          cummunity.id)
                                                      .then((value) {
                                                    if (value) {
                                                      context.pop();
                                                      context.go('/community');
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: "삭제에 실패하였습니다.",
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white);
                                                    }
                                                  });
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  child: Text('삭제'),
                                                ),
                                              ),
                                            ]),
                                    barrierDismissible: true);
                              },
                              child: const Text('삭제하기'),
                            ),
                          ],
                        )
                      : Row(),
                  CommentWidget(id: cummunity.id),
                ],
              ),
            )
          : LoadingPage(height: MediaQuery.of(context).size.height),
    );
  }
}
