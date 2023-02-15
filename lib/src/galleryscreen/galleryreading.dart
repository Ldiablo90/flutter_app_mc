import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/gallerymodel.dart';
import 'package:maccave/widgets/comment.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

enum MenuItem { delete, edit, share }

class GalleryReading extends StatefulWidget {
  const GalleryReading({super.key, required this.id});
  final String id;

  @override
  State<GalleryReading> createState() => _GalleryReadingState();
}

class _GalleryReadingState extends State<GalleryReading> {
  late GalleryModel gallery;
  bool galleryLoading = true;
  bool favorite = false;
  bool cummunityOrner = false;
  int likes = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String timeToString(DateTime createdate) {
    final nowtime = DateFormat('yyyy.MM/dd HH:mm').format(createdate);
    return nowtime;
  }

  Future<void> getGallerydata() async {
    final temp = await FireStoreData.getGalleryItem(widget.id);
    if (temp != null) {
      if (temp.userid == _auth.currentUser!.uid) {
        cummunityOrner = true;
      }
      setState(() {
        galleryLoading = false;
        gallery = temp;
      });
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

  Future<void> setFavorite() async {
    final favoritetemp =
        await FireStoreData.getFavorite(widget.id, 'gallerylikes');
    final gallCount = await FireStoreData.getGalleryCount(widget.id);

    setState(() {
      favorite = favoritetemp;
      likes = gallCount;
    });
  }

  @override
  void initState() {
    setFavorite();
    getGallerydata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: ''),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: !galleryLoading
              ? Column(
                  children: [
                    FutureBuilder(
                      future: FireStoreData.getUser(id: gallery.userid),
                      builder: (context, usersnapshot) {
                        if (usersnapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Image.network(
                                      usersnapshot.data!.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${usersnapshot.data!.name} 님'),
                                      Text(timeToString(gallery.createdate))
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onSelected: (value) {
                                    if (value == MenuItem.share) {
                                    } else if (value == MenuItem.edit) {
                                      context.pushNamed('galleryeidt',
                                          params: {"id": widget.id});
                                    } else if (value == MenuItem.delete) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  const Text('게시물을 삭제하시겠습니까?'),
                                              actions: [
                                                InkWell(
                                                  onTap: () {
                                                    context.pop();
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 15),
                                                    child: Text('취소'),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    FireStoreData
                                                            .removeGalleryItem(
                                                                widget.id)
                                                        .then((value) {
                                                      if (value) {
                                                        context.pop();
                                                        context.go('/gallery');
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 15),
                                                    child: Text('삭제'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) {
                                    if (cummunityOrner) {
                                      return [
                                        const PopupMenuItem(
                                          value: MenuItem.share,
                                          child: Text('공유'),
                                        ),
                                        const PopupMenuItem(
                                          value: MenuItem.edit,
                                          child: Text('수정'),
                                        ),
                                        const PopupMenuItem(
                                          value: MenuItem.delete,
                                          child: Text('삭제'),
                                        ),
                                      ];
                                    } else {
                                      return [
                                        const PopupMenuItem(
                                          value: MenuItem.share,
                                          child: Text('공유'),
                                        )
                                      ];
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        return LoadingPage(height: 30);
                      },
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        // disableCenter: true,
                        viewportFraction: 1.0,
                        height: 300,
                        enableInfiniteScroll: false,
                        scrollPhysics: const BouncingScrollPhysics(),
                      ),
                      items: gallery.images
                          .map(
                            (image) => Image.network(
                              // 'https://picsum.photos/seed/${gallery.id}/400/400',
                              image,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Icon(Icons.image_outlined);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              FireStoreData.setFavorite(
                                  widget.id, 'gallerylikes');

                              setState(() {
                                likes = favorite ? likes - 1 : likes + 1;
                                favorite = !favorite;
                              });
                            },
                            child: favorite
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red[300],
                                  )
                                : const Icon(Icons.favorite_border),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: const Icon(Icons.logout_outlined),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '공감 ${likes}개',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [Expanded(child: Text(gallery.title))],
                    ),
                    CommentWidget(id: widget.id),
                  ],
                )
              : LoadingPage(height: 30),
        ),
      ),
    );
  }
}
