import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class MyContentScreen extends StatefulWidget {
  const MyContentScreen({super.key, required this.id});
  final String id;
  @override
  State<MyContentScreen> createState() => _MyContentScreenState();
}

class _MyContentScreenState extends State<MyContentScreen> {
  int _cummuCount = 0;
  int _gallCount = 0;
  bool loadding = true;

  void initDataState() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
              future: FireStoreData.getUserOnlyCummunity(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _cummuCount = snapshot.data!.length;
                  final itemSize = MediaQuery.of(context).size.width * 0.5;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              '커뮤니티',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Text('$_cummuCount'),
                          ],
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: snapshot.data!
                            .map((cummunity) => InkWell(
                                  onTap: () {
                                    context.pushNamed('cummunityread',
                                        params: {"id": cummunity.id});
                                  },
                                  child: Container(
                                    color: Colors.grey[300],
                                    width: itemSize,
                                    height: itemSize,
                                    child: Center(
                                      child: Text(
                                        cummunity.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(fontSize: 21),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  );
                }
                return LoadingPage(height: 150);
              },
            ),
            FutureBuilder(
              future: FireStoreData.getUserOnlyGallery(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _gallCount = snapshot.data!.length;
                  final itemSize = MediaQuery.of(context).size.width * 0.5;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              '겔러리',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Text('$_gallCount'),
                          ],
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: snapshot.data!
                            .map((gallery) => InkWell(
                                  onTap: () {
                                    context.pushNamed(
                                      'galleryreading',
                                      params: {"id": gallery.id},
                                    );
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    width: itemSize,
                                    height: itemSize,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: itemSize,
                                          height: itemSize,
                                          child: Image.network(
                                            gallery.images[0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  );
                }
                return LoadingPage(height: 150);
              },
            ),
            // Row(
            //   children: [
            //     Column(
            //       children: [
            //         FutureBuilder(
            //           builder: (context, snapshot) {
            //             return LoadingPage(height: 150);
            //           },
            //         ),
            //       ],
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
