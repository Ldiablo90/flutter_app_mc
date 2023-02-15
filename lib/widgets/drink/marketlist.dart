import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/entrymodel.dart';
import 'package:maccave/models/marketmodel.dart';
import 'package:maccave/widgets/loddinpage.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key? key, required this.entrys}) : super(key: key);
  final List<EntryModel> entrys;

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  Widget build(BuildContext context) {
    if (widget.entrys.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            ...widget.entrys.map((entry) => MarketListItem(entry: entry)),
          ],
        ),
      );
    }
    return Container();
  }
}

class MarketListItem extends StatefulWidget {
  const MarketListItem({Key? key, required this.entry}) : super(key: key);
  final EntryModel entry;

  @override
  State<MarketListItem> createState() => _MarketListItemState();
}

class _MarketListItemState extends State<MarketListItem> {
  String releaseDate() {
    final result = DateFormat('M/d 판매').format(widget.entry.releasedate);
    return result;
  }

  String priceFormat() {
    final result = NumberFormat('###,###,###,###원').format(widget.entry.price);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: .5,
            blurRadius: 3,
            offset: Offset(1.5, 1.5),
          )
        ],
      ),
      child: FutureBuilder(
        future: FireStoreData.getMarketItem(widget.entry.marketid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${snapshot.data!.name} ${priceFormat()}'),
                Text(releaseDate()),
              ],
            );
          }
          return LoadingPage(height: 45);
        },
      ),
    );
  }
}
