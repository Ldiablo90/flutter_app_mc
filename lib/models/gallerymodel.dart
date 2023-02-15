class GalleryModel {
  final String id;
  final String title;
  final List<dynamic> images;
  final String? userid;
  final List<dynamic>? likes;
  final DateTime createdate;

  GalleryModel({
    required this.id,
    required this.title,
    required this.images,
    this.userid,
    this.likes,
    required this.createdate,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    DateTime createtemp =
        DateTime.parse(json['createdate'].toDate().toString());

    return GalleryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      images: (json['images'] as List).cast<String>(),
      likes: (json['likes'] as List).cast<String>(),
      userid: json['userid'] as String,
      createdate: createtemp,
    );
  }
}
