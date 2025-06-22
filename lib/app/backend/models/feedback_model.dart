class FeedbackModel {
  int? id; // Feedback ID
  int? uid; // User ID
  int? freelancerId; // Freelancer ID
  int? salonId; // Salon ID
  int? specialistId; // Specialist ID
  String? feedbackText; // Feedback text
  double? rating; // Rating given by the user
  DateTime? createdAt; // Timestamp of feedback creation

  FeedbackModel({
    this.id,
    this.uid,
    this.freelancerId,
    this.salonId,
    this.specialistId,
    this.feedbackText,
    this.rating,
    this.createdAt,
  });

  // Convert FeedbackModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return {
      data['id']: id,
      data['uid']: uid,
      data['freelancerId']: freelancerId,
      data['salonId']: salonId,
      data['specialistId']: specialistId,
      data['feedbackText']: feedbackText,
      data['rating']: rating,
      data['createdAt']: createdAt?.toIso8601String(),
    };
  }

  // Create FeedbackModel from JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: int.parse(json['id'].toString()),
      uid: int.parse(json['uid'].toString()),
      freelancerId: int.parse(json['freelancerId'].toString()),
      salonId: int.parse(json['salonId'].toString()),
      specialistId: int.parse(json['specialistId'].toString()),
      feedbackText: json['feedbackText'],
      rating: double.parse(json['rating'].toString()),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}