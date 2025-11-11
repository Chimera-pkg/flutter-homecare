import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nursing/data/models/add_on_service_model.dart';
import 'package:m2health/features/nursing/data/models/personal_issue.dart';
import 'package:m2health/features/nursing/data/models/professional_model.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/utils.dart';

abstract class NursingRemoteDataSource {
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<List<AddOnServiceModel>> getAddOnServices(String serviceType);

  Future<List<PersonalIssue>> getPersonalIssues();
  Future<void> createPersonalIssue(PersonalIssueModel data);
  Future<void> updatePersonalIssue(int id, PersonalIssueModel data);
  Future<void> deletePersonalIssue(int issueId);

  Future<List<ProfessionalModel>> getProfessionals(String serviceType);
  Future<ProfessionalModel> getProfessionalDetail(String serviceType, int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  final Dio dio;

  NursingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_MEDICAL_RECORDS,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception('Failed to fetch medical records');
    }
  }

  @override
  Future<List<AddOnServiceModel>> getAddOnServices(String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    log('Fetching add-on services for $serviceType',
        name: 'NursingRemoteDataSourceImpl');

    final response = await dio.get(
      '${Const.URL_API}/service-titles',
      queryParameters: {'service_type': serviceType},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    log('Response data: ${response.data}', name: 'NursingRemoteDataSourceImpl');

    final services = (response.data as List)
        .map((service) => AddOnServiceModel.fromJson(service))
        .toList();
    return services;
  }

  @override
  Future<List<ProfessionalModel>> getProfessionals(String serviceType,
      {String? name}) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.get(
        '${Const.URL_API}/professionals',
        queryParameters: {
          'provider_type': serviceType,
          if (name != null) 'name': name,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final professionals = response.data['data'] as List;
      return professionals
          .map((prof) => ProfessionalModel.fromJson(prof))
          .toList();
    } catch (e) {
      log('Error fetching professionals',
          error: e, name: 'NursingRemoteDataSourceImpl');
      rethrow;
    }
  }

  @override
  Future<ProfessionalModel> getProfessionalDetail(
      String serviceType, int id) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final response = await dio.get(
      '${Const.URL_API}/professionals/$id',
      queryParameters: {
        'provider_type': serviceType,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final data = response.data['data'];
      return ProfessionalModel.fromJson(data);
    } else {
      throw Exception('Failed to load professional detail');
    }
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    final userId = await Utils.getSpString(Const.USER_ID);
    final token = await Utils.getSpString(Const.TOKEN);

    if (isFavorite) {
      final data = {
        'user_id': userId,
        'item_id': professionalId,
        'item_type': 'nurse', // Assuming nurse for now
        'highlighted': 1,
      };
      final response = await dio.post(
        Const.API_FAVORITES,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update favorite status');
      }
    } else {
      final data = {
        'user_id': userId,
        'item_id': professionalId,
        'item_type': 'nurse',
      };
      final response = await dio.delete(
        Const.API_FAVORITES,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete favorite');
      }
    }
  }

  @override
  Future<List<PersonalIssue>> getPersonalIssues() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_PERSONAL_ISSUES,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return (response.data['data'] as List)
        .map((issue) => PersonalIssueModel.fromJson(issue))
        .toList();
  }

  @override
  Future<void> createPersonalIssue(PersonalIssueModel data) async {
    final token = await Utils.getSpString(Const.TOKEN);

    List<MultipartFile> imageFiles = [];
    for (final image in data.images) {
      imageFiles.add(await MultipartFile.fromFile(image.path));
    }

    final payload = FormData.fromMap({
      ...data.toJson(),
      'images': imageFiles,
    });

    final response = await dio.post(
      Const.API_PERSONAL_ISSUES,
      data: payload,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 201) {
      log('Response data: ${response.data}',
          name: 'NursingRemoteDataSourceImpl');
      throw Exception('Failed to create nursing issue');
    }
  }

  Future<void> updatePersonalIssue(int id, PersonalIssueModel data) async {
    final token = await Utils.getSpString(Const.TOKEN);

    List<MultipartFile> imageFiles = [];
    for (final image in data.images) {
      imageFiles.add(await MultipartFile.fromFile(image.path));
    }

    final payload = FormData.fromMap({
      ...data.toJson(),
      if (imageFiles.isNotEmpty) 'images': imageFiles,
    });

    final response = await dio.put(
      '${Const.API_PERSONAL_ISSUES}/$id',
      data: payload,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update nursing issue');
    }
  }

  @override
  Future<void> deletePersonalIssue(int issueId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.delete(
      '${Const.API_PERSONAL_ISSUES}/$issueId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete nursing issue');
    }
  }
}
