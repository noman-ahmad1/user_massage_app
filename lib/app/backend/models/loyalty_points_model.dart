class LoyaltyHistoryModel {
  final String uuid;
  final String description;
  final int points;
  final String createdAt;

  LoyaltyHistoryModel({
    required this.uuid,
    required this.description,
    required this.points,
    required this.createdAt,
  });

  factory LoyaltyHistoryModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyHistoryModel(
      uuid: json['uuid'] ?? '',
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'description': description,
      'points': points,
      'created_at': createdAt,
    };
  }
}
