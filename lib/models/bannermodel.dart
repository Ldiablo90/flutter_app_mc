class BannerModel {
  final String id;
  final String image;

  BannerModel({
    required this.id,
    required this.image,
  });
  BannerModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id']! as String,
          image: json['image']! as String,
        );
}
