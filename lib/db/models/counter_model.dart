class CounterModel {
  static const defaultMaxCount = 200;
  static const defaultWarningLevel = 170;

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
    this.maxCount = defaultMaxCount,
    this.warningAtCount = defaultWarningLevel,
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