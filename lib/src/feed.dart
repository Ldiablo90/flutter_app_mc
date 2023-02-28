import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firebaseauth.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/feed/feeditem.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/widgets/maincacheimage.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String timeNowtoString() {
    final nowtime = DateFormat('M월 d일').format(DateTime.now());
    return nowtime;
  }

  String timeTomorrowtoString() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final nowtime = DateFormat('M월 d일').format(tomorrow);
    return nowtime;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(apptitle: '피드페이지', center: true),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  FutureBuilder(
                    future: FireStoreData.getBanners(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return CarouselSlider(
                          items: snapshot.data!
                              .map(
                                (banner) => MainCacheImage(
                                  // 'https://picsum.photos/seed/${banner.id}/400/260',
                                  imageUrl: banner.image,
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            height: 260,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                          ),
                        );
                      }
                      return LoadingPage(height: 200);
                    },
                  ),
                  FutureBuilder(
                    future: FireStoreData.getEntryTosDate(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('${timeNowtoString()} 실시간 정보 '),
                                      Text(
                                        '(${snapshot.data!.length})',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.push('/feed/entrylist');
                                    },
                                    child: const Icon(Icons.tune),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...snapshot.data!.map<Widget>((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: FeedItem(entry: entry),
                                  )),
                              snapshot.data!.isEmpty
                                  ? Text('오늘의 정보가 없습니다.')
                                  : SizedBox()
                            ],
                          ),
                        );
                      }
                      return LoadingPage(height: 250);
                    },
                  ),
                  FutureBuilder(
                    future: FireStoreData.getEntryTosDate('tomorrow'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('${timeTomorrowtoString()}~ 예정 정보 '),
                                      Text(
                                        '(${snapshot.data!.length})',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.push('/feed/entrylist');
                                    },
                                    child: const Icon(Icons.tune),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...snapshot.data!.map<Widget>((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: FeedItem(entry: entry),
                                  )),
                              snapshot.data!.isEmpty
                                  ? Text('예정된 정보가 없습니다.')
                                  : SizedBox()
                            ],
                          ),
                        );
                      }
                      return LoadingPage(height: 250);
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        children: [],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
