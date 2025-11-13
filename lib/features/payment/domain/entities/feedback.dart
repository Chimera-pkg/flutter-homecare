import 'package:equatable/equatable.dart';

class FeedbackEntity extends Equatable {
  final int id;
  final int userId;
  final int appointmentId;
  final int stars;
  final String? text;
  final String? tips;
  final DateTime createdAt;

  const FeedbackEntity({
    required this.id,
    required this.userId,
    required this.appointmentId,
    required this.stars,
    this.text,
    this.tips,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, appointmentId, stars, text, tips, createdAt];
}