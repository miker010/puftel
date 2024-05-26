class MoodTypeModel{
  final int id;
  String description;
  String title;

  MoodTypeModel({
    required this.id,
    required this.description,
    required this.title
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'title': title
    };
  }
}