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
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: drinkList.map<Widget>((drink) {
                        return Container(
                          width: MediaQuery.of(context).size.width * .42,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 4),
                              )
                            ],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(
                                'drinkitem',
                                params: {"id": drink.id, 'title': drink.name},
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .42,
                                  child: Image.network(
                                    drink.image,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                ),
                                Text(
                                  drink.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  drink.type,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          : LoadingPage(height: 150),
    );
  }
}
