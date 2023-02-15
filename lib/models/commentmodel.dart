class CommentModel {
  final String id;
  final String userid;
  final String typeid;
  final String comment;
  final List<dynamic>? likes;
  final DateTime? createdate;

  CommentModel({
    required this.id,
    required this.userid,
    required this.typeid,
    required this.comment,
    required this.likes,
    required this.createdate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    DateTime useSetTime(int seconds) {
      int temp = (seconds * 1000) + 32400000;
      return DateTime.fromMillisecondsSinceEpoch(temp);
    }

    DateTime createtemp =
        DateTime.parse(json['createdate'].toDate().toString());

    return CommentModel(
      id: json['id'] as String,
      userid: json['userid'] as String,
      typeid: json['typeid'] as String,
      comment: json['comment'] as String,
      likes: json['likes'] != null ? json['likes'] as List<dynamic> : [],
      createdate: createtemp,
    );
  }
}
