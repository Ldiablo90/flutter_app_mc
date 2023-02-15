class MarketModel {
  final String id;
  final String name;
  final String image;
  final String place;
  final String opening;
  final String col;

  MarketModel({
    required this.id,
    required this.name,
    required this.image,
    required this.place,
    required this.opening,
    required this.col,
  });
  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      place: json['place'] as String,
      opening: json['opening'] as String,
      col: json['col'] as String,
    );
  }
}
