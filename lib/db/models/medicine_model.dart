class MedicineModel {

  final int id;
  final String name;
  final String description;
  final int color;
  final String link;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.description,
    this.color = 0,
    this.link = ""
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color' : color,
      'link' : link
    };
  }
}