import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/create_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/delete_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/get_personal_issues.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/update_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';

class PersonalIssuesCubit extends Cubit<PersonalIssuesState> {
  final GetPersonalIssues getPersonalIssues;
  final CreatePersonalIssue createPersonalIssue;
  final UpdatePersonalIssue updatePersonalIssue;
  final DeletePersonalIssue deletePersonalIssue;

  PersonalIssuesCubit({
    required String serviceType,
    required this.getPersonalIssues,
    required this.createPersonalIssue,
    required this.updatePersonalIssue,
    required this.deletePersonalIssue,
  }) : super(PersonalIssuesState.initial(serviceType: serviceType));

  Future<void> loadNursingIssues() async {
    emit(state.copyWith(
      loadStatus: ActionStatus.loading,
      loadErrorMessage: null,
    ));
    final result = await getPersonalIssues(state.serviceType);
    result.fold(
      (failure) {
        log('Failed to load issues: ${failure.toString()}',
            name: 'PersonalIssuesCubit');
        emit(state.copyWith(
          loadStatus: ActionStatus.error,
          loadErrorMessage: failure.toString(),
        ));
      },
      (issues) {
        log('Loaded ${issues.length} issues', name: 'PersonalIssuesCubit');
        final validSelectedIds = state.selectedIssueIds
            .where((id) => issues.any((issue) => issue.id == id))
            .toList();
        emit(state.copyWith(
          loadStatus: ActionStatus.success,
          issues: issues,
          selectedIssueIds: validSelectedIds,
        ));
      },
    );
  }

  void toggleIssueSelection(int issueId) {
    final newSelectedIds = List<int>.from(state.selectedIssueIds);
    if (newSelectedIds.contains(issueId)) {
      newSelectedIds.remove(issueId);
    } else {
      newSelectedIds.add(issueId);
    }
    emit(state.copyWith(selectedIssueIds: newSelectedIds));
  }

  void setSelectedIssues(List<PersonalIssue> issues) {
    final selectedIds = issues.map((issue) => issue.id!).toList();
    emit(state.copyWith(selectedIssueIds: selectedIds));
  }

  Future<void> addIssue(PersonalIssue issue) async {
    emit(state.copyWith(
      createStatus: ActionStatus.loading,
      createErrorMessage: null,
    ));
    log('Adding issue: ${issue.title}, ${issue.description}, images count: ${issue.images.length}',
        name: 'PersonalIssuesCubit');
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
      (newIssue) async {
        log('Issue added successfully', name: 'PersonalIssuesCubit');
        final newSelectedIds = List<int>.from(state.selectedIssueIds)
          ..add(newIssue.id!);
        emit(state.copyWith(
          createStatus: ActionStatus.success,
          selectedIssueIds: newSelectedIds,
        ));
        await loadNursingIssues();
      },
    );
  }

  Future<void> updateIssue(int issueId, PersonalIssue issue) async {
    emit(state.copyWith(
      updateStatus: ActionStatus.loading,
      updateErrorMessage: null,
    ));
    log('Updating issue: ${issue.title}, ${issue.description}, images count: ${issue.images.length}',
        name: 'PersonalIssuesCubit');
    final result = await updatePersonalIssue(issueId, issue);
    result.fold(
      (failure) {
        log('Failed to update issue: ${failure.toString()}',
            name: 'PersonalIssuesCubit');
        emit(state.copyWith(
          updateStatus: ActionStatus.error,
          updateErrorMessage: 'Failed to update issue. Please try again.',
        ));
      },
      (updatedIssue) async {
        log('Issue updated successfully', name: 'PersonalIssuesCubit');
        emit(state.copyWith(
          updateStatus: ActionStatus.success,
        ));
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
        final newSelectedIds = List<int>.from(state.selectedIssueIds)
          ..remove(issueId);
        emit(state.copyWith(
            deleteStatus: ActionStatus.success,
            selectedIssueIds: newSelectedIds));
        await loadNursingIssues();
      },
    );
  }
}
