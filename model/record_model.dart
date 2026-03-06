class RecordModel {
  final int violationId;
  final String date;
  final String recordedBy;

  RecordModel({
    required this.violationId,
    required this.date,
    required this.recordedBy,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      violationId: json['violation']?['id'] ?? 0,
      date: json['createdAt'] ?? "",
      recordedBy: json['recordedBy']?['name'] ?? "N/A",
    );
  }
}
