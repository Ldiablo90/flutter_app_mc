import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/cummunitymodel.dart';
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
            const Divider(color: Colors.black),
            FutureBuilder(
              future: FireStoreData.getCummunitys(type),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: PaginatedDataTable(
                      horizontalMargin: 0,
                      columnSpacing: 10,
                      dataRowHeight: 30,
                      headingRowHeight: 30,
                      showCheckboxColumn: false,
                      columns: const <DataColumn>[
                        DataColumn(label: Center(child: Text('번호'))),
                        DataColumn(label: Center(child: Text('제목'))),
                        DataColumn(label: Center(child: Text('일자'))),
                      ],
                      source: MyData(
                          data: snapshot.data!.asMap().entries.toList(),
                          context: context),
                    ),
                    // child: DataTable(
                    //   horizontalMargin: 0,
                    //   columnSpacing: 10,
                    //   dataRowHeight: 30,
                    //   headingRowHeight: 30,
                    //   showCheckboxColumn: false,
                    //   columns: const <DataColumn>[
                    //     DataColumn(label: Center(child: Text('번호'))),
                    //     DataColumn(label: Center(child: Text('제목'))),
                    //     DataColumn(label: Center(child: Text('일자'))),
                    //   ],
                    //   rows: <DataRow>[
                    //     ...snapshot.data!.asMap().entries.map<DataRow>(
                    //           (cummu) => DataRow(
                    //             onSelectChanged: (value) {
                    //               context.pushNamed('cummunityread',
                    //                   params: {"id": cummu.value.id});
                    //             },
                    //             cells: [
                    //               DataCell(Center(
                    //                 child: Text(
                    //                     '${snapshot.data!.length - cummu.key}'),
                    //               )),
                    //               DataCell(
                    //                 SizedBox(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             .60,
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(cummu.value.title),
                    //                         FutureBuilder(
                    //                           future: FireStoreData
                    //                               .getCommentsCount(
                    //                                   cummu.value.id),
                    //                           builder:
                    //                               (context, commentsnapshot) {
                    //                             if (commentsnapshot.hasData &&
                    //                                 commentsnapshot.data! > 0) {
                    //                               return Padding(
                    //                                 padding: const EdgeInsets
                    //                                         .symmetric(
                    //                                     horizontal: 5),
                    //                                 child: Text(
                    //                                     '(${commentsnapshot.data!})'),
                    //                               );
                    //                             }
                    //                             return const Text('');
                    //                           },
                    //                         ),
                    //                       ],
                    //                     )),
                    //               ),
                    //               DataCell(
                    //                   Text(dateChange(cummu.value.createdate))),
                    //             ],
                    //           ),
                    //         ),
                    //   ],
                    // ),
                  );
                }
                return LoadingPage(height: 200);
              },
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

class MyData extends DataTableSource {
  MyData({required this.data, required this.context}) : super();
  List<MapEntry<int, CummunityModel>> data;
  BuildContext context;
  // Generate some made-up data
  // final List<Map<String, dynamic>> _data = List.generate(
  //     200, (index) => {"id": index, "title": "Item $index", "price": 15000});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
        onSelectChanged: (value) {
          context
              .pushNamed('cummunityread', params: {"id": data[index].value.id});
        },
        cells: [
          DataCell(Center(
            child: Text('${data.length - data[index].key}'),
          )),
          DataCell(
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data[index].value.title),
                    FutureBuilder(
                      future:
                          FireStoreData.getCommentsCount(data[index].value.id),
                      builder: (context, commentsnapshot) {
                        if (commentsnapshot.hasData &&
                            commentsnapshot.data! > 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text('(${commentsnapshot.data!})'),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ],
                )),
          ),
          DataCell(Text(
              DateFormat('yy.MM.dd').format(data[index].value.createdate))),
        ]);
  }
}
