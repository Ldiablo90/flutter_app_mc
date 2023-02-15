import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/drinkmodel.dart';

class DrinkInfo extends StatefulWidget {
  DrinkInfo({Key? key, required this.drink}) : super(key: key);
  DrinkModel drink;

  @override
  State<DrinkInfo> createState() => _DrinkInfoState();
}

class _DrinkInfoState extends State<DrinkInfo> {
  bool favorite = false;

  Future<void> setFavorite() async {
    final drink =
        await FireStoreData.getFavorite(widget.drink.id, 'drinklikes');
    setState(() {
      favorite = drink;
    });
  }

  @override
  void initState() {
    setFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double imgWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: imgWidth,
          child: Image.network(
            // 'https://picsum.photos/seed/${widget.drink.id}/400/400',
            widget.drink.image,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.drink.place,
                  style: const TextStyle(),
                ),
                Text(
                  widget.drink.name,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  widget.drink.name_en,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: InkWell(
                onTap: () {
                  FireStoreData.setFavorite(widget.drink.id, 'drinklikes');
                  setState(() {
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
            )
          ],
        ),
      ],
    );
  }
}
