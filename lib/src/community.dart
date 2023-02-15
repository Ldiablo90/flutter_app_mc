import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/blackelevatedbtn.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String type = '전체글';
  int selectIndex = 0;
  int startitem = 0;

  static const tabs = [
    '전체글',
    '발매정보',
    'bar장소',
    '기타',
    '공지사항',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String dateChange(DateTime createdate) {
    final timeNow = DateTime.now();
    String result = '';
    if (timeNow.difference(createdate).inHours >= 24) {
      result = DateFormat('yy.MM.dd').format(createdate);
    } else {
      result = DateFormat('HH:mm').format(createdate);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final b_width = MediaQuery.of(context).size.width * .15;
    return Scaffold(
      appBar: CustomAppBar(apptitle: '커뮤니티', center: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabs
                    .asMap()
                    .entries
                    .map(
                      (tab) => InkWell(
                        onTap: () {
                          setState(() {
                            type = tab.value;
                            selectIndex = tab.key;
                            startitem = 0;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 25),
                          decoration: selectIndex == tab.key
                              ? const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.black,
                                )
                              : BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.grey[300],
                                ),
                          child: Center(
                            child: Text(
                              tab.value,
                              style: TextStyle(
                                color: selectIndex == tab.key
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 1)),
              ),
              child: FutureBuilder(
                future: FireStoreData.getCummunitys(type),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final pagecount = List.generate(
                        (snapshot.data!.length / 15).ceil(),
                        ((index) => index));

                    final lastitem = pagecount.length > 1
                        ? pagecount.length % 15 == 0
                            ? startitem + 15
                            : startitem + pagecount.length % 15
                        : startitem + snapshot.data!.length;

                    return Column(
                      children: [
                        ...snapshot.data!
                            .sublist(startitem, lastitem)
                            .asMap()
                            .entries
                            .map((cummunity) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: .5),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('cummunityread',
                                    params: {"id": cummunity.value.id});
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                          '${snapshot.data!.length - cummunity.key}'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      cummunity.value.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: FireStoreData.getCommentsCount(
                                        cummunity.value.id),
                                    builder: (context, commentsnapshot) {
                                      if (commentsnapshot.hasData &&
                                          commentsnapshot.data! > 0) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                              '(${commentsnapshot.data!})'),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                  SizedBox(
                                    width: 55,
                                    child: Text(
                                      dateChange(
                                        cummunity.value.createdate,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: pagecount
                                .map((count) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              startitem = count * 15;
                                            });
                                          },
                                          child: Text('${count + 1}')),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  }
                  return LoadingPage(height: 50);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MacCaveElevatedButton(
                    onPressed: () {
                      context.push('/community/writing');
                    },
                    child: const Text('글쓰기'),
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
