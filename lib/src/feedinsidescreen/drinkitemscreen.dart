import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/entrymodel.dart';
import 'package:maccave/widgets/comment.dart';
import 'package:maccave/widgets/drink/drinkinfo.dart';
import 'package:maccave/widgets/drink/marketlist.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';

class DrinkItemScreen extends StatefulWidget {
  const DrinkItemScreen({Key? key, required this.id, required this.title})
      : super(key: key);
  final String id;
  final String title;

  @override
  State<DrinkItemScreen> createState() => _DrinkItemScreenState();
}

class _DrinkItemScreenState extends State<DrinkItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: widget.title),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder(
                  future: FireStoreData.getDrinkItem(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            DrinkInfo(drink: snapshot.data!),
                            FutureBuilder(
                              future: FireStoreData.getEntrys(
                                  id: snapshot.data!.id),
                              builder: (context,
                                  AsyncSnapshot<List<EntryModel>> snapshot) {
                                if (snapshot.hasData) {
                                  return MarketList(entrys: snapshot.data!);
                                }
                                return LoadingPage(height: 300);
                              },
                            ),
                            CommentWidget(id: snapshot.data!.id),
                          ],
                        ),
                      );
                    }
                    return LoadingPage(
                        height: MediaQuery.of(context).size.height);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
