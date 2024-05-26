class TodayModel {

  final int id;
  String name;
  int value;

  List<TodayModel>? specifications;

  TodayModel({
    required this.id,
    required this.name,
    required this.value
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value
    };
  }
}