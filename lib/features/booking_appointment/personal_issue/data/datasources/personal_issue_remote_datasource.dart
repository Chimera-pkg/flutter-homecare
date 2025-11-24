import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/utils.dart';

abstract class PersonalIssueRemoteDataSource {
  Future<List<PersonalIssue>> getPersonalIssues(String serviceType);
  Future<PersonalIssueModel> createPersonalIssue(PersonalIssueModel data);
  Future<PersonalIssueModel> updatePersonalIssue(
      int id, PersonalIssueModel data);
  Future<void> deletePersonalIssue(int issueId);
}

class PersonalIssueRemoteDataSourceImpl
    implements PersonalIssueRemoteDataSource {
  final Dio dio;

  PersonalIssueRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PersonalIssue>> getPersonalIssues(String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final params = {'type': serviceType};
    final response = await dio.get(
      Const.API_PERSONAL_ISSUES,
      queryParameters: params,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    log('Response data: ${response.data}',
        name: 'PersonalIssueRemoteDataSourceImpl');

    return (response.data['data'] as List)
        .map((issue) => PersonalIssueModel.fromJson(issue))
        .toList();
  }

  @override
  Future<PersonalIssueModel> createPersonalIssue(
      PersonalIssueModel data) async {
    final token = await Utils.getSpString(Const.TOKEN);

    List<MultipartFile> imageFiles = [];
    for (final image in data.images) {
      imageFiles.add(await MultipartFile.fromFile(image.path));
    }

    final payload = FormData.fromMap({
      ...data.toJson(),
      'images[]': imageFiles,
    });

    try {
      final response = await dio.post(
        Const.API_PERSONAL_ISSUES,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log('Create personal issue success. Response data: ${response.data}',
          name: 'PersonalIssueRemoteDataSourceImpl');
      return PersonalIssueModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) {
        log('DioError during createPersonalIssue: ${e.response?.data}',
            name: 'PersonalIssueRemoteDataSourceImpl');
        rethrow;
      }
      log('Error during createPersonalIssue: $e',
          name: 'PersonalIssueRemoteDataSourceImpl');
      rethrow;
    }
  }

  @override
  Future<PersonalIssueModel> updatePersonalIssue(
      int id, PersonalIssueModel data) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final payloadMap = <String, dynamic>{
      ...data.toJson(),
    };

    if (data.newImages.isNotEmpty) {
      final List<MultipartFile> imageFiles = [];
      final List<int> imageIndices = [];
      for (final entry in data.newImages.entries) {
        imageFiles.add(await MultipartFile.fromFile(entry.value.path));
        imageIndices.add(entry.key);
      }
      payloadMap['images[]'] = imageFiles;
      payloadMap['images_indices[]'] = imageIndices;
    }

    final payload = FormData.fromMap(payloadMap);
    log('Update payload: $payloadMap',
        name: 'PersonalIssueRemoteDataSourceImpl');

    try {
      final response = await dio.put(
        '${Const.API_PERSONAL_ISSUES}/$id',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      log('Update personal issue success. Response data: ${response.data}',
          name: 'PersonalIssueRemoteDataSourceImpl');
      return PersonalIssueModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) {
        log('DioError during updatePersonalIssue: ${e.response?.data}',
            name: 'PersonalIssueRemoteDataSourceImpl');
        rethrow;
      }
      log('Error during updatePersonalIssue: $e',
          name: 'PersonalIssueRemoteDataSourceImpl');
      rethrow;
    }
  }

  @override
  Future<void> deletePersonalIssue(int issueId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.delete(
        '${Const.API_PERSONAL_ISSUES}/$issueId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log('Delete personal issue success. Response data: ${response.data}',
          name: 'PersonalIssueRemoteDataSourceImpl');
    } catch (e) {
      if (e is DioException) {
        log('DioError during deletePersonalIssue: ${e.response?.data}',
            name: 'PersonalIssueRemoteDataSourceImpl');
        rethrow;
      }
      log('Error during deletePersonalIssue: $e',
          name: 'PersonalIssueRemoteDataSourceImpl');
      rethrow;
    }
  }
}
