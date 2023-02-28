import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/cummunitymodel.dart';
import 'package:maccave/widgets/cummunity/cummunityitem.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '커뮤니티', center: true),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              context.push('/community/writing');
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ),
      ),
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
                          type = tab.value;
                          selectIndex = tab.key;
                          setState(() {});
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
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: FireStoreData.getCummunitys(type),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: LiveList(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index, animation) => CummunityItem(
                        animation: animation,
                        model: snapshot.data![index],
                      ),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text('새로운 소식을 알려주세요.'),
                    ),
                  );
                }
                return LoadingPage(height: 200);
              },
            ),
          ],
        ),
      ),
    );
  }
}
