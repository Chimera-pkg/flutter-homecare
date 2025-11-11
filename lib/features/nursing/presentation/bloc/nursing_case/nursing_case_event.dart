import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/mobility_status.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';

sealed class NursingCaseEvent extends Equatable {
  const NursingCaseEvent();

  @override
  List<Object?> get props => [];
}

class GetNursingCaseEvent extends NursingCaseEvent {}

class InitializeNursingCaseEvent extends NursingCaseEvent {}

class SelectServiceTypeEvent extends NursingCaseEvent {
  final NurseServiceType serviceType;

  const SelectServiceTypeEvent(this.serviceType);

  @override
  List<Object?> get props => [serviceType];
}

class CreateNursingCaseEvent extends NursingCaseEvent {
  final NursingCase nursingCase;

  const CreateNursingCaseEvent(this.nursingCase);

  @override
  List<Object> get props => [nursingCase];
}

class AddPersonalIssueEvent extends NursingCaseEvent {
  final PersonalIssue issue;

  const AddPersonalIssueEvent(this.issue);

  @override
  List<Object> get props => [issue];
}

class DeletePersonalIssueEvent extends NursingCaseEvent {
  final PersonalIssue issue;

  const DeletePersonalIssueEvent(this.issue);

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

class FetchNursingAddOnServices extends NursingCaseEvent {
  final NurseServiceType serviceType;

  const FetchNursingAddOnServices(this.serviceType);

  @override
  List<Object?> get props => [serviceType];
}

class ToggleAddOnService extends NursingCaseEvent {
  final AddOnService service;
  const ToggleAddOnService(this.service);
}

class UpdateCaseWithAppointment extends NursingCaseEvent {
  final int appointmentId;
  final NursingCase nursingCase; // Pass the case data to be saved

  const UpdateCaseWithAppointment({
    required this.appointmentId,
    required this.nursingCase,
  });

  @override
  List<Object?> get props => [appointmentId, nursingCase];
}
