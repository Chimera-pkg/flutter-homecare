import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/const.dart';
import 'package:m2health/utils.dart';
import 'nursing_personal_state.dart';

class NursingPersonalCubit extends Cubit<NursingPersonalState> {
  NursingPersonalCubit() : super(NursingPersonalInitial());

  void loadPersonalDetails({NurseServiceType? serviceType}) async {
    emit(NursingPersonalLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().get(
        Const.API_NURSING_PERSONAL_CASES,
        queryParameters: {'service_type': 'nurse'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log('Response status code: ${response.statusCode}',
          name: 'NursingPersonalCubit');
      log('Response data: ${response.data}', name: 'NursingPersonalCubit');

      if (response.statusCode == 200) {
        final dataList = response.data['data']['data'] as List;
        var issues =
            dataList.map((json) => NursingIssue.fromJson(json)).toList();

        log('Filtered issues for $serviceType: ${issues.length}',
            name: 'NursingPersonalCubit');
        emit(NursingPersonalLoaded(issues));
      } else {
        log('Failed to load data: ${response.statusMessage}',
            name: 'NursingPersonalCubit');
        emit(const NursingPersonalError('Failed to load data'));
      }
    } catch (e, stackTrace) {
      log('Error: $e',
          name: 'NursingPersonalCubit', error: e, stackTrace: stackTrace);
      if (e is DioException && e.response?.statusCode == 401) {
        emit(const NursingPersonalUnauthenticated());
      } else {
        emit(NursingPersonalError(e.toString()));
      }
    }
  }

  // void addIssue(Issue issue) async {
  //   if (state is NursingPersonalLoaded) {
  //     final currentState = state as NursingPersonalLoaded;
  //     final updatedIssues = List<Issue>.from(currentState.issues)..add(issue);
  //     emit(NursingPersonalLoaded(updatedIssues));

  //     try {
  //       final token = await Utils.getSpString(Const.TOKEN);
  //       await Dio().post(
  //         Const.API_NURSING_PERSONAL_CASES,
  //         data: issue.toJson(),
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Bearer $token',
  //           },
  //         ),
  //       );
  //     } catch (e) {
  //       emit(NursingPersonalError(e.toString()));
  //     }
  //   }
  // }

  void addIssue(NursingIssue issue) async {
    if (state is NursingPersonalLoaded) {
      final currentState = state as NursingPersonalLoaded;
      final updatedIssues = List<NursingIssue>.from(currentState.issues)
        ..add(issue);
      emit(NursingPersonalLoaded(updatedIssues));

      try {
        final token = await Utils.getSpString(Const.TOKEN);
        final response = await Dio().post(
          'https://homecare-api.med-map.org/v1/nursing/personal-cases/',
          data: issue.toJson(),
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          log("✅ Issue berhasil ditambahkan: ${response.data}",
              name: 'NursingPersonalCubit');
        } else {
          log("⚠️ Gagal menambahkan issue: ${response.statusMessage}",
              name: 'NursingPersonalCubit');
          emit(const NursingPersonalError('Failed to add issue to server'));
        }
      } catch (e, stackTrace) {
        log("❌ Error saat addIssue: $e",
            name: 'NursingPersonalCubit', error: e, stackTrace: stackTrace);
        emit(NursingPersonalError(e.toString()));
      }
    }
  }

  void deleteIssue(int index) async {
    if (state is NursingPersonalLoaded) {
      final currentState = state as NursingPersonalLoaded;
      final issue = currentState.issues[index];
      final updatedIssues = List<NursingIssue>.from(currentState.issues)
        ..removeAt(index);
      emit(NursingPersonalLoaded(updatedIssues));

      try {
        final token = await Utils.getSpString(Const.TOKEN);
        final response = await Dio().delete(
          '${Const.API_NURSING_PERSONAL_CASES}/${issue.id}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode != 200) {
          // If the delete request failed, re-add the issue to the state
          updatedIssues.insert(index, issue);
          emit(NursingPersonalLoaded(updatedIssues));
          emit(const NursingPersonalError(
              'Failed to delete issue from the database'));
        }
      } catch (e) {
        // If the delete request failed, re-add the issue to the state
        updatedIssues.insert(index, issue);
        emit(NursingPersonalLoaded(updatedIssues));
        emit(NursingPersonalError(e.toString()));
      }
    }
  }
}
