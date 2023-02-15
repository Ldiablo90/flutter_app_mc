import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:maccave/firebaseserver/firestoredata.dart';
import 'package:maccave/models/commentmodel.dart';
import 'package:maccave/widgets/loddinpage.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({Key? key, required this.id}) : super(key: key);
  final String? id;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _commentField = TextEditingController();
  bool _commentError = false;
  void saveComment() async {
    if (_commentError) {
      print('saveComment');
      FireStoreData.setComment(_commentField.text, widget.id!);
      _commentField.clear();

      setState(() {
        _commentError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextField(
                controller: _commentField,
                decoration: const InputDecoration(
                  hintText: '댓글 추가...',
                ),
                onChanged: (value) {
                  setState(() {
                    _commentError = value.isNotEmpty ? true : false;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(width: .5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: InkWell(
                  onTap: saveComment,
                  child: Text(
                    '게시',
                    style: TextStyle(
                      color: _commentError ? Colors.black : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        FutureBuilder(
          future: FireStoreData.getComments(widget.id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Text('댓글 ${snapshot.data!.length} >'),
                      ],
                    ),
                  ),
                  ...snapshot.data!
                      .map((model) => CommentWidgetItem(model: model))
                ],
              );
            }
            return LoadingPage(height: 250);
          },
        )
      ],
    );
  }
}

class CommentWidgetItem extends StatefulWidget {
  const CommentWidgetItem({Key? key, required this.model}) : super(key: key);
  final CommentModel model;

  @override
  State<CommentWidgetItem> createState() => _CommentWidgetItemState();
}

class _CommentWidgetItemState extends State<CommentWidgetItem> {
  String dateinfoFormat(String userName) {
    final result = DateFormat('${userName}   yyyy.MM.dd hh:mm')
        .format(widget.model.createdate!);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStoreData.getUser(id: widget.model.userid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      snapshot.data!.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateinfoFormat(snapshot.data!.name),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Text(
                        widget.model.comment,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                // SizedBox(
                //   child: InkWell(
                //     child: Icon(Icons.thumb_up_alt),
                //   ),
                // ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
