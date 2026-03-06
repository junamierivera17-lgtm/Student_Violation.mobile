class ViolationModel {
  final int id;
  final String name;
  final String description;

  ViolationModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  get level => null;
}
