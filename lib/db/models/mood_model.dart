// CREATE TABLE mood (id INTEGER PRIMARY KEY, dateTime INTEGER, value INTEGER, description TEXT, counterId INTEGER)');

class MoodModel {
  final int id;
  String description;
  final int value;
  final int dateTime;
  final int moodTypeId;

  MoodModel({
    required this.id,
    required this.dateTime,
    required this.value,
    required this.moodTypeId,
    this.description = ""
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'dateTime': dateTime,
      'moodTypeId': moodTypeId
    };
  }
}