import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

enum ActionStatus {
  initial,
  loading,
  success,
  error,
}

final class PersonalIssuesState extends Equatable {
  final String serviceType;
  final List<PersonalIssue> issues;

  final ActionStatus loadStatus;
  final String? loadErrorMessage;

  final ActionStatus createStatus;
  final String? createErrorMessage;

  final ActionStatus deleteStatus;
  final String? deleteErrorMessage;

  const PersonalIssuesState({
    required this.serviceType,
    this.issues = const [],
    this.loadStatus = ActionStatus.initial,
    this.loadErrorMessage,
    this.createStatus = ActionStatus.initial,
    this.createErrorMessage,
    this.deleteStatus = ActionStatus.initial,
    this.deleteErrorMessage,
  });

  @override
  List<Object?> get props => [
        issues,
        loadStatus,
        loadErrorMessage,
        createStatus,
        createErrorMessage,
        deleteStatus,
        deleteErrorMessage,
      ];

  PersonalIssuesState copyWith({
    String? serviceType,
    List<PersonalIssue>? issues,
    ActionStatus? loadStatus,
    String? loadErrorMessage,
    ActionStatus? createStatus,
    String? createErrorMessage,
    ActionStatus? deleteStatus,
    String? deleteErrorMessage,
  }) {
    return PersonalIssuesState(
      serviceType: serviceType ?? this.serviceType,
      issues: issues ?? this.issues,
      loadStatus: loadStatus ?? this.loadStatus,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      createStatus: createStatus ?? this.createStatus,
      createErrorMessage: createErrorMessage ?? this.createErrorMessage,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,
    );
  }

  factory PersonalIssuesState.initial({required String serviceType}) {
    return PersonalIssuesState(serviceType: serviceType);
  }
}
