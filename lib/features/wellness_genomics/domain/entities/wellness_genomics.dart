import 'package:equatable/equatable.dart';

class WellnessGenomics extends Equatable {
  final int? id;
  final int? userId;
  final String? fullReportPath;
  final String? createdAt;
  final String? updatedAt;

  const WellnessGenomics({
    this.id,
    this.userId,
    this.fullReportPath,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fullReportPath,
        createdAt,
        updatedAt,
      ];
}
