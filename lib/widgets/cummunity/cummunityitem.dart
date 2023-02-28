import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:maccave/models/cummunitymodel.dart';
import 'package:go_router/go_router.dart';

class CummunityItem extends StatelessWidget {
  CummunityItem({super.key, required this.model, required this.animation});
  CummunityModel model;
  final Animation<double> animation;

  String dateChange(DateTime createdate) {
    final timeNow = DateTime.now();
    String result = '';
    if (timeNow.difference(createdate).inHours >= 24) {
      result = DateFormat('yy.MM.dd').format(createdate);
    } else {
      result = DateFormat('yy.MM.dd HH:mm').format(createdate);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, .1),
          end: Offset.zero,
        ).animate(animation),
        child: InkWell(
          onTap: () {
            context.pushNamed('cummunityread', params: {"id": model.id});
          },
          child: Container(
            height: 80,
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: .5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          model.type,
                          style: TextStyle(
                            color: model.type == '발매정보'
                                ? Colors.amber
                                : model.type == 'bar장소'
                                    ? Colors.red
                                    : model.type == '기타'
                                        ? Colors.blue
                                        : Colors.green,
                          ),
                        ),
                        Text(
                          dateChange(model.createdate),
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FutureBuilder(
                        future: FireStoreData.getUser(id: model.userid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.name,
                              style: TextStyle(fontSize: 12),
                            );
                          }
                          return Text('Loadding...');
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
