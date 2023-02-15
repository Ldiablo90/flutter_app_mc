class PrivacysModel {
  final String id;
  final String content;

  PrivacysModel({
    required this.id,
    required this.content,
  });
  PrivacysModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id']! as String,
          content: json['content']! as String,
        );
}
