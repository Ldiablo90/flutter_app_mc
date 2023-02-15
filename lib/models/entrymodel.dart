class EntryModel {
  final String id;
  final String type;
  final int price;
  final DateTime? createdate;
  final DateTime releasedate;
  final String drinkid;
  final String marketid;

  EntryModel({
    required this.id,
    required this.type,
    required this.price,
    required this.createdate,
    required this.releasedate,
    required this.drinkid,
    required this.marketid,
  });

  factory EntryModel.fromJson(Map<String, dynamic> json) {
    DateTime useSetTime(int seconds) {
      int temp = (seconds * 1000) + 32400000;
      return DateTime.fromMillisecondsSinceEpoch(temp);
    }

    DateTime createtemp =
        DateTime.parse(json['createdate'].toDate().toString());
    DateTime releasetemp =
        DateTime.parse(json['releasedate'].toDate().toString());

    return EntryModel(
      id: json['id'] as String,
      type: json['type'] as String,
      price: json['price'] as int,
      createdate: createtemp,
      releasedate: releasetemp,
      drinkid: json['drinkid'] as String,
      marketid: json['marketid'] as String,
    );
  }
}
