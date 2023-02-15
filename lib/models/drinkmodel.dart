class DrinkModel {
  final String id;
  final String name;
  final String name_en;
  final String type;
  final String image;
  final String place;
  final int alcohol;
  final DateTime releasedate;

  DrinkModel({
    required this.id,
    required this.name,
    required this.name_en,
    required this.type,
    required this.image,
    required this.place,
    required this.alcohol,
    required this.releasedate,
  });

  factory DrinkModel.fromJson(Map<String, dynamic> json) {
    DateTime releasetemp =
        DateTime.parse(json['releasedate'].toDate().toString());
    return DrinkModel(
      id: json['id'] as String,
      name: json['name'] as String,
      name_en: json['name_en'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      place: json['place'] as String,
      alcohol: json['alcohol'] as int,
      releasedate: releasetemp,
    );
  }
}
