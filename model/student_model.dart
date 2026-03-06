class StudentModel {
  final int id;
  final String name;
  final String studentId;
  final String email;
  final String? course;
  final int? yearLevel;

  StudentModel({
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    this.course,
    this.yearLevel,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      studentId: json['studentId'],
      email: json['email'],
      course: json['course'],
      yearLevel: json['yearLevel'],
    );
  }
}
