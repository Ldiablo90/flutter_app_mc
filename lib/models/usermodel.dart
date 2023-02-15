class UserModel {
  final String id;
  final String email;
  final String name;
  final num mileage_points;
  final List<dynamic> drinklikes;
  final List<dynamic> gallerylikes;
  final String image;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.mileage_points,
    required this.drinklikes,
    required this.gallerylikes,
    required this.image,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']! as String,
      email: json['email']! as String,
      name: json['name']! as String,
      mileage_points: json['mileage_points']! as num,
      drinklikes: (json['drinklikes']! as List).cast<String>(),
      gallerylikes: (json['gallerylikes']! as List).cast<String>(),
      image: json['image'] != ''
          ? json['image'] as String
          : "https://placekitten.com/g/200/200",
    );
  }
}
