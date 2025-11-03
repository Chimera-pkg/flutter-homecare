import 'package:equatable/equatable.dart';

class ReviewerEntity extends Equatable {
  final String name;
  final String avatar;

  const ReviewerEntity({required this.name, required this.avatar});

  @override
  List<Object?> get props => [name, avatar];
}

class ReviewEntity extends Equatable {
  final int id;
  final ReviewerEntity reviewer;
  final double score;
  final String description;

  const ReviewEntity({
    required this.id,
    required this.reviewer,
    required this.score,
    required this.description,
  });

  @override
  List<Object?> get props => [id, reviewer, score, description];
}
