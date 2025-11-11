import 'package:m2health/features/nursingclean/domain/entities/reviewer.dart';

class ReviewerModel extends ReviewerEntity {
  const ReviewerModel({
    required super.name,
    required super.avatar,
  });

  factory ReviewerModel.fromJson(Map<String, dynamic> json) {
    return ReviewerModel(
      name: json['name'] ?? 'Anonymous',
      avatar: json['avatar'] ?? '',
    );
  }
}

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.reviewer,
    required super.score,
    required super.description,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      reviewer: ReviewerModel.fromJson(json['reviewer'] ?? {}),
      score: (json['score'] as num).toDouble(),
      description: json['description'] ?? '',
    );
  }
}
