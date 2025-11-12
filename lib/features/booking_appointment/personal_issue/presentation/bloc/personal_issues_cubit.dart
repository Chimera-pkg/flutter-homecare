import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/create_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/delete_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/get_personal_issues.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';

class PersonalIssuesCubit extends Cubit<PersonalIssuesState> {
  final GetPersonalIssues getPersonalIssues;
  final CreatePersonalIssue createPersonalIssue;
  final DeletePersonalIssue deletePersonalIssue;

  PersonalIssuesCubit({
    required this.getPersonalIssues,
    required this.createPersonalIssue,
    required this.deletePersonalIssue,
  }) : super(PersonalIssuesState.initial());

  Future<void> loadNursingIssues() async {
    emit(state.copyWith(
      loadStatus: ActionStatus.loading,
      loadErrorMessage: null,
    ));
    final result = await getPersonalIssues();
    result.fold(
      (failure) => emit(state.copyWith(
        loadStatus: ActionStatus.error,
        loadErrorMessage: failure.toString(),
      )),
      (issues) => emit(state.copyWith(
        loadStatus: ActionStatus.success,
        issues: issues,
      )),
    );
  }

  Future<void> addIssue(PersonalIssue issue) async {
    emit(state.copyWith(
      createStatus: ActionStatus.loading,
      createErrorMessage: null,
    ));
    log('Adding issue: ${issue.title}, ${issue.description}, images count: ${issue.images.length}');
    final result = await createPersonalIssue(issue);
    result.fold(
      (failure) {
        log('Failed to add issue: ${failure.toString()}',
            name: 'PersonalIssuesCubit');
        emit(state.copyWith(
          createStatus: ActionStatus.error,
          createErrorMessage: 'Failed to add issue. Please try again.',
        ));
      },
      (_) async {
        log('Issue added successfully');
        emit(state.copyWith(createStatus: ActionStatus.success));
        await loadNursingIssues();
      },
    );
  }

  Future<void> deleteIssue(int issueId) async {
    emit(state.copyWith(
      deleteStatus: ActionStatus.loading,
      deleteErrorMessage: null,
    ));

    final result = await deletePersonalIssue(issueId);
    result.fold(
      (failure) {
        log('Failed to delete issue: ${failure.toString()}',
            name: 'PersonalIssuesCubit');
        emit(state.copyWith(
          deleteStatus: ActionStatus.error,
          deleteErrorMessage: 'Failed to delete issue. Please try again.',
        ));
      },
      (_) async {
        emit(state.copyWith(deleteStatus: ActionStatus.success));
        await loadNursingIssues();
      },
    );
  }
}
