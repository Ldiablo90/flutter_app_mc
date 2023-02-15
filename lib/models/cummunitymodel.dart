import 'package:maccave/firebaseserver/firestoredata.dart';

class CummunityModel {
  final String id;
  final String type;
  final String title;
  final String userid;
  final String content;
  final DateTime createdate;

  CummunityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.userid,
    required this.createdate,
  });

  factory CummunityModel.fromJson(Map<String, dynamic> json) {
    DateTime createtemp =
        DateTime.parse(json['createdate'].toDate().toString());
    return CummunityModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      userid: json['userid'] as String,
      createdate: createtemp,
    );
  }
}
