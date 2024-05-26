class LogModel {

  final int id;
  final String name;
  final int value;
  final int dateTime;
  final int color;
  final int counterId;

  const LogModel({
    required this.id,
    required this.dateTime,
    required this.name,
    required this.value,
    this.color = 0,
    this.counterId = 0
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'dateTime': dateTime,
      'color' : color,
      'counterId' : counterId,
    };
  }


}