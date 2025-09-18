import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'personal_state.dart';

class PersonalCubit extends Cubit<PersonalState> {
  late final Dio _dio;

  PersonalCubit() : super(PersonalInitial()) {
    _dio = Dio();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await Utils.getSpString(Const.TOKEN);
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
      ),
    );
  }

  void loadPersonalDetails({String? serviceType}) async {
    emit(PersonalLoading());
    try {
      final queryParameters = <String, String>{};
      if (serviceType != null) {
        queryParameters['service_type'] = serviceType.toLowerCase();
      }

      final response = await _dio.get(
        Const.API_PERSONAL_CASES,
        queryParameters: queryParameters,
      );

      final data = response.data['data'] as List;
      final issues = data.map((json) => Issue.fromJson(json)).toList();
      issues.forEach((issue) => issue.updateImageUrls());

      emit(PersonalLoaded(issues));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(PersonalUnauthenticated());
        return;
      }
      emit(PersonalError('Failed to load data: ${e.message}'));
    } catch (e) {
      print(e);
      emit(PersonalError(e.toString()));
    }
  }

  void addIssue(Issue issue) async {
    final currentState = state;
    if (currentState is! PersonalLoaded) return;

    final updatedIssues = List<Issue>.from(currentState.issues)..add(issue);
    emit(PersonalLoaded(updatedIssues));

    try {
      await _dio.post(Const.API_PERSONAL_CASES, data: issue.toJson());
    } catch (e) {
      emit(PersonalLoaded(currentState.issues)); // Rollback on failure
      emit(PersonalError('Failed to add issue: ${e.toString()}'));
    }
  }

  void updateIssue(Issue updatedIssue) async {
    final currentState = state;
    if (currentState is! PersonalLoaded) return;

    final int index =
        currentState.issues.indexWhere((issue) => issue.id == updatedIssue.id);
    if (index == -1) return;

    final updatedIssuesList = List<Issue>.from(currentState.issues);
    updatedIssuesList[index] = updatedIssue;

    emit(PersonalLoaded(updatedIssuesList));

    try {
      await _dio.put(
        '${Const.API_PERSONAL_CASES}/${updatedIssue.id}',
        data: updatedIssue.toJson(),
      );
    } catch (e) {
      emit(PersonalLoaded(currentState.issues));
      emit(PersonalError('Failed to update issue: ${e.toString()}'));
    }
  }

  void deleteIssue(int index) async {
    final currentState = state;
    if (currentState is! PersonalLoaded) return;
    if (index < 0 || index >= currentState.issues.length) return;

    final issueToDelete = currentState.issues[index];
    final updatedIssues = List<Issue>.from(currentState.issues)
      ..removeAt(index);
    emit(PersonalLoaded(updatedIssues));

    try {
      await _dio.delete('${Const.API_PERSONAL_CASES}/${issueToDelete.id}');
    } catch (e) {
      emit(PersonalLoaded(currentState.issues)); // Rollback on failure
      emit(PersonalError('Failed to delete issue: ${e.toString()}'));
    }
  }
}
