import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'personal_state.dart';

class PersonalCubit extends Cubit<PersonalState> {
  PersonalCubit() : super(PersonalInitial());

  void loadPersonalDetails({String? serviceType}) async {
    emit(PersonalLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      print('Token: $token');

      // Build API endpoint with optional filtering
      String apiUrl = Const.API_PERSONAL_CASES;
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
        final data = response.data['data'] as List;
        var issues = data.map((json) => Issue.fromJson(json)).toList();
        // Client-side filtering as backup if backend doesn't support filtering
        if (serviceType != null) {
          issues = issues.where((issue) {
            final caseType = issue.caseType?.toLowerCase() ?? '';
            switch (serviceType.toLowerCase()) {
              case 'pharma':
              case 'pharmacist':
                return caseType == 'pharmacy' || caseType == 'pharmacist';
              case 'nurse':
                return caseType == 'nursing' || caseType == 'nurse';
              case 'radiologist':
                return caseType == 'radiology' || caseType == 'radiologist';
              default:
                return true;
            }
          }).toList();
        }

        issues.forEach((issue) => issue.updateImageUrls());
        print('Filtered issues for $serviceType: ${issues.length}');
        emit(PersonalLoaded(issues));
      } else {
        print('Failed to load data: ${response.statusMessage}');
        emit(const PersonalError('Failed to load data'));
      }
    } catch (e) {
      print('Error: $e');
      emit(PersonalError(e.toString()));
    }
  }

  void addIssue(Issue issue) async {
    if (state is PersonalLoaded) {
      final currentState = state as PersonalLoaded;
      final updatedIssues = List<Issue>.from(currentState.issues)..add(issue);
      emit(PersonalLoaded(updatedIssues));

      try {
        final token = await Utils.getSpString(Const.TOKEN);
        await Dio().post(
          '${Const.API_PERSONAL_CASES}',
          data: issue.toJson(),
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
      } catch (e) {
        emit(PersonalError(e.toString()));
      }
    }
  }

  void deleteIssue(int index) async {
    if (state is PersonalLoaded) {
      final currentState = state as PersonalLoaded;
      final issue = currentState.issues[index];
      final updatedIssues = List<Issue>.from(currentState.issues)
        ..removeAt(index);
      emit(PersonalLoaded(updatedIssues));

      try {
        final token = await Utils.getSpString(Const.TOKEN);
        final response = await Dio().delete(
          '${Const.API_PERSONAL_CASES}/${issue.id}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode != 200) {
          // If the delete request failed, re-add the issue to the state
          updatedIssues.insert(index, issue);
          emit(PersonalLoaded(updatedIssues));
          emit(const PersonalError('Failed to delete issue from the database'));
        }
      } catch (e) {
        // If the delete request failed, re-add the issue to the state
        updatedIssues.insert(index, issue);
        emit(PersonalLoaded(updatedIssues));
        emit(PersonalError(e.toString()));
      }
    }
  }
}
