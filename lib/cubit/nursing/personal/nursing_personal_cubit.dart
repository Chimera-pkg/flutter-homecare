import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'nursing_personal_state.dart';

class NursingPersonalCubit extends Cubit<NursingPersonalState> {
  NursingPersonalCubit() : super(NursingPersonalInitial());

  void loadPersonalDetails({String? serviceType}) async {
    emit(NursingPersonalLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      print('Token: $token');

      // Build API endpoint with optional filtering
      String apiUrl = Const.API_NURSING_PERSONAL_CASES;
      if (serviceType != null) {
        // Add query parameter for filtering by service type
        apiUrl += '?service_type=${serviceType.toLowerCase()}';
      }

      final response = await Dio().get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final dataList = response.data['data']['data'] as List;
        var issues =
            dataList.map((json) => NursingIssue.fromJson(json)).toList();

        // Client-side filtering as backup if backend doesn't support filtering
        // if (serviceType != null) {
        //   issues = issues.where((issue) {
        //     final caseType = issue.caseType?.toLowerCase() ?? '';
        //     switch (serviceType.toLowerCase()) {
        //       case 'pharma':
        //       case 'pharmacist':
        //         return caseType == 'pharmacy' || caseType == 'pharmacist';
        //       case 'nurse':
        //         return caseType == 'nursing' || caseType == 'nurse';
        //       case 'radiologist':
        //         return caseType == 'radiology' || caseType == 'radiologist';
        //       default:
        //         return true;
        //     }
        //   }).toList();
        // }

        issues.forEach((issue) => issue.updateImageUrls());
        print('Filtered issues for $serviceType: ${issues.length}');
        emit(NursingPersonalLoaded(issues));
      } else {
        print('Failed to load data: ${response.statusMessage}');
        emit(const NursingPersonalError('Failed to load data'));
      }
    } on DioException catch (e) {
      print(e.error);
      if (e.response?.statusCode == 401) {
        emit(NursingPersonalUnauthenticated());
        return;
      }
      emit(NursingPersonalError('Failed to load data: ${e.message}'));
    } catch (e) {
      print('Error: $e');
      emit(NursingPersonalError(e.toString()));
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
          print("✅ Issue berhasil ditambahkan: ${response.data}");
        } else {
          print("⚠️ Gagal menambahkan issue: ${response.statusMessage}");
          emit(const NursingPersonalError('Failed to add issue to server'));
        }
      } catch (e, stackTrace) {
        print("❌ Error saat addIssue: $e");
        print(stackTrace);
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
