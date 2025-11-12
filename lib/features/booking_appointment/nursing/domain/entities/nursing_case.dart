import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

class NursingCase extends Equatable {
  final int? appointmentId;
  final List<PersonalIssue> issues;
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;
  final List<AddOnService> addOnServices;

  const NursingCase({
    this.appointmentId,
    required this.issues,
    this.mobilityStatus,
    this.relatedHealthRecordId,
    required this.addOnServices,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        issues,
        mobilityStatus,
        relatedHealthRecordId,
        addOnServices,
      ];

  NursingCase copyWith({
    int? appointmentId,
    List<PersonalIssue>? issues,
    MobilityStatus? mobilityStatus,
    int? relatedHealthRecordId,
    List<AddOnService>? addOnServices,
    double? estimatedBudget,
  }) {
    return NursingCase(
      appointmentId: appointmentId ?? this.appointmentId,
      issues: issues ?? this.issues,
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId: relatedHealthRecordId,
      addOnServices: addOnServices ?? this.addOnServices,
    );
  }
}
