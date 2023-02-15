import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:go_router/go_router.dart';
import 'package:maccave/models/drinkmodel.dart';
import 'package:maccave/models/entrymodel.dart';
import 'package:maccave/models/marketmodel.dart';
import 'package:maccave/widgets/loddinpage.dart';

class FeedItem extends StatefulWidget {
  const FeedItem({Key? key, required this.entry}) : super(key: key);

  final EntryModel entry;
  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool favorite = false;
  bool dataLoading = true;
  late DrinkModel drink;
  late MarketModel market;

  String formatReleaseDate() {
    final result = DateFormat('yyyy.MM.dd 판매').format(widget.entry.releasedate);
    return result;
  }

  Future<void> setDataInitState() async {
    drink = await FireStoreData.getDrinkItem(widget.entry.drinkid);
    market = await FireStoreData.getMarketItem(widget.entry.marketid);
    favorite =
        await FireStoreData.getFavorite(widget.entry.drinkid, 'drinklikes');
    dataLoading = false;
    setState(() {});
  }

  Future<void> setFavorite() async {}

  Future<void> setUserData() async {}

  @override
  void initState() {
    setDataInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !dataLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            child: InkWell(
              onDoubleTap: () {
                context.pushNamed(
                  'drinkitem',
                  params: {"id": drink.id, 'title': drink.name},
                );
              },
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: InkWell(
                      onTap: () {
                        FireStoreData.setFavorite(drink.id, 'drinklikes');
                        setState(() {
                          favorite = !favorite;
                        });
                      },
                      child: favorite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red[300],
                            )
                          : Icon(Icons.favorite_border),
                    ),
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                          width: 92,
                          height: 92,
                          child: Image.network(
                            // 'https://picsum.photos/seed/${snapshot.data!.id}/100/100',
                            drink.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drink.place,
                            style: const TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              drink.name,
                              style: const TextStyle(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Text(market.name),
                          Text(formatReleaseDate(),
                              style: const TextStyle(fontSize: 10))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : LoadingPage(height: 300);
  }
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: FireStoreData.getDrinkItem(widget.entry.drinkid),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return Container(
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             // border: Border.all(width: 1, color: Colors.black),
  //             borderRadius: BorderRadius.circular(5),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 1,
  //                 blurRadius: 5,
  //                 offset: Offset(3, 3),
  //               ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
  //           child: InkWell(
  //             onDoubleTap: () {
  //               context.pushNamed(
  //                 'drinkitem',
  //                 params: {
  //                   "id": snapshot.data!.id,
  //                   'title': snapshot.data!.name,
  //                 },
  //               );
  //             },
  //             child: Stack(
  //               children: [
  //                 Align(
  //                   alignment: AlignmentDirectional.topEnd,
  //                   child: InkWell(
  //                     onTap: () {
  //                       FireStoreData.setFavorite(
  //                           snapshot.data!.id, 'drinklikes');
  //                       setState(() {
  //                         favorite = !favorite;
  //                       });
  //                     },
  //                     child: favorite
  //                         ? Icon(
  //                             Icons.favorite,
  //                             color: Colors.red[300],
  //                           )
  //                         : Icon(Icons.favorite_border),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     SizedBox(
  //                       width: 92,
  //                       height: 92,
  //                       child: Image.network(
  //                         // 'https://picsum.photos/seed/${snapshot.data!.id}/100/100',
  //                         snapshot.data!.image,
  //                         fit: BoxFit.cover,
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return const Icon(Icons.error);
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(snapshot.data!.place),
  //                         Text(snapshot.data!.name),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       } else {
  //         return LoadingPage(height: 200);
  //       }
  //     },
  //   );
  // }
}
