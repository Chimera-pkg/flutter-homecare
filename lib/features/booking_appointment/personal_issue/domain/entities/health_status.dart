import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';

class HealthStatus extends Equatable {
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;

  const HealthStatus({
    this.mobilityStatus,
    this.relatedHealthRecordId,
  });

  @override
  List<Object?> get props => [
        mobilityStatus,
        relatedHealthRecordId,
      ];

  HealthStatus copyWith({
    MobilityStatus? mobilityStatus,
    int? relatedHealthRecordId,
  }) {
    return HealthStatus(
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId:
          relatedHealthRecordId ?? this.relatedHealthRecordId,
    );
  }
}
