import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/drinkmodel.dart';
import 'package:maccave/models/usermodel.dart';
import 'package:maccave/widgets/loddinpage.dart';
import 'package:maccave/widgets/mainappbar.dart';
import 'package:go_router/go_router.dart';

class MyDrinkList extends StatefulWidget {
  const MyDrinkList({super.key, required this.id});
  final String id;
  @override
  State<MyDrinkList> createState() => _MyDrinkListState();
}

class _MyDrinkListState extends State<MyDrinkList> {
  late UserModel user;
  bool loading = true;
  List<DrinkModel> drinkList = [];

  Future<void> initDataState() async {
    user = await FireStoreData.getUser(id: widget.id);
    drinkList = await FireStoreData.getUserLikeDrinks(user.drinklikes);
    loading = true;
    setState(() {});
  }

  @override
  void initState() {
    initDataState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(apptitle: '내술찜리스트'),
      body: loading
          ? Column(
              children: [
                ...drinkList.map<Widget>((drink) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          'drinkitem',
                          params: {"id": drink.id, 'title': drink.name},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Row(
                          children: [
                            Text(drink.name),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            )
          : LoadingPage(height: 150),
    );
  }
}
