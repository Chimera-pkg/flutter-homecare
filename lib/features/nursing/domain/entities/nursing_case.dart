import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/mobility_status.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_issue.dart';

// This structure is used to manage the details of a nursing appointment.
// In backend systems, it corresponds to the NursePersonalCase.
// This structure normalized duplicate data, such mobility status, which is shared across multiple cases.
class NursingCase extends Equatable {
  final int? appointmentId;
  final String? careType;
  final List<NursingIssue> issues;
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;
  final List<AddOnService> addOnServices;
  final double estimatedBudget;

  const NursingCase({
    this.appointmentId,
    this.careType,
    required this.issues,
    this.mobilityStatus,
    this.relatedHealthRecordId,
    required this.addOnServices,
    required this.estimatedBudget,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        careType,
        issues,
        mobilityStatus,
        relatedHealthRecordId,
        addOnServices,
        estimatedBudget,
      ];

  NursingCase copyWith({
    int? appointmentId,
    String? careType,
    List<NursingIssue>? issues,
    MobilityStatus? mobilityStatus,
    int? relatedHealthRecordId,
    List<AddOnService>? addOnServices,
    double? estimatedBudget,
  }) {
    return NursingCase(
      appointmentId: appointmentId ?? this.appointmentId,
      careType: careType ?? this.careType,
      issues: issues ?? this.issues,
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId: relatedHealthRecordId,
      addOnServices: addOnServices ?? this.addOnServices,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
    );
  }
}
