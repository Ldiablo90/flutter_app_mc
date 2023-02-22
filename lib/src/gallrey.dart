import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:maccave/widgets/maincacheimage.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
      appBar: CustomAppBar(apptitle: 'GALLERY', center: true),
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              context.push('/gallery/writing');
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: FutureBuilder(
          future: FireStoreData.getGallerys(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (snapshot.hasData)
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: snapshot.data!.map((gallery) {
                              final widthsize =
                                  MediaQuery.of(context).size.width * 0.5;
                              return InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    'galleryreading',
                                    params: {"id": gallery.id},
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            spreadRadius: 0,
                                            blurRadius: 0,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: SizedBox(
                                          width: widthsize,
                                          height: widthsize,
                                          child: MainCacheImage(
                                            // 'https://picsum.photos/seed/${gallery.id}/200/200',
                                            imageUrl: gallery.images[0],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // gallery.userid
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        else
                          Center(
                            child: LoadingPage(height: 300),
                          )
                      ],
                    ),
                  ),
                  if (snapshot.hasData)
                    SliverGrid.count(
                      crossAxisCount: 2,
                      children: [],
                    ),
                ],
              );
            }
            return LoadingPage(height: 300);
          },
        ),
      ),
    );
  }
}
