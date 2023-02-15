import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/feed/feeditem.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

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
                                (banner) => Image.network(
                                  // 'https://picsum.photos/seed/${banner.id}/400/260',
                                  banner.image,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Icon(Icons.image_outlined);
                                  },
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
                    future: FireStoreData.getEntrys(),
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
                                  ))
                            ],
                          ),
                        );
                      }
                      return const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
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
