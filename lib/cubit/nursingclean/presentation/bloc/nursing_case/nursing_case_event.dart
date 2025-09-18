import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/mobility_status.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';

sealed class NursingCaseEvent extends Equatable {
  const NursingCaseEvent();

  @override
  List<Object?> get props => [];
}

class GetNursingCaseEvent extends NursingCaseEvent {}

class InitializeNursingCaseEvent extends NursingCaseEvent {}

class CreateNursingCaseEvent extends NursingCaseEvent {
  final NursingCase nursingCase;

  const CreateNursingCaseEvent(this.nursingCase);

  @override
  List<Object> get props => [nursingCase];
}

class AddNursingIssueEvent extends NursingCaseEvent {
  final NursingIssue issue;

  const AddNursingIssueEvent(this.issue);

  @override
  List<Object> get props => [issue];
}

class DeleteNursingIssueEvent extends NursingCaseEvent {
  final NursingIssue issue;

  const DeleteNursingIssueEvent(this.issue);

  @override
  List<Object> get props => [issue];
}

class UpdateHealthStatusNursingCaseEvent extends NursingCaseEvent {
  final MobilityStatus? mobilityStatus;
  final int? relatedHealthRecordId;

  const UpdateHealthStatusNursingCaseEvent({
    this.mobilityStatus,
    this.relatedHealthRecordId,
  });

  @override
  List<Object?> get props => [mobilityStatus, relatedHealthRecordId];
}

class HealthStatusConfirmedEvent extends NursingCaseEvent {}

class FetchNursingAddOnServices extends NursingCaseEvent {}

class ToggleAddOnService extends NursingCaseEvent {
  final AddOnService service;
  const ToggleAddOnService(this.service);
}

// class UpdateNursingCaseEvent extends NursingCaseEvent {
//   final String caseId;
//   final Map<String, dynamic> data;

//   const UpdateNursingCaseEvent(this.caseId, this.data);

//   @override
//   List<Object> get props => [caseId, data];
// }
