import 'package:m2health/features/payment/domain/entities/feedback.dart';

class FeedbackModel extends FeedbackEntity {
  const FeedbackModel({
    required super.id,
    required super.userId,
    required super.appointmentId,
    required super.stars,
    super.text,
    super.tips,
    required super.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['user_id'],
      appointmentId: json['appointment_id'],
      stars: json['stars'],
      text: json['text'],
      tips: json['tips'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'stars': stars,
      'text': text,
      'tips': tips,
    };
  }
}