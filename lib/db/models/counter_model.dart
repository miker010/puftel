class CounterModel {

  final int id;
  String name;
  String description;
  final int warningAtCount;
  final int maxCount;
  int value;
  int color;
  String link;

  CounterModel({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
    this.maxCount = 200,
    this.warningAtCount = 170,
    this.color = 0,
    this.link = ""
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
      'maxCount': maxCount,
      'warningAtCount': warningAtCount,
      'color' : color,
      'link' : link
    };
  }
}