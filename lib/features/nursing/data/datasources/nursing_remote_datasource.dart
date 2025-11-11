import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nursing/data/models/add_on_service_model.dart';
import 'package:m2health/features/nursing/data/models/nursing_personal_case.dart';
import 'package:m2health/features/nursing/data/models/professional_model.dart';
import 'package:m2health/utils.dart';

abstract class NursingRemoteDataSource {
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<List<AddOnServiceModel>> getAddOnServices(String serviceType);

  Future<List<NursingPersonalCaseModel>> getNursingPersonalCases();
  Future<NursingPersonalCaseModel> createNursingCase(
      NursingPersonalCaseModel data);
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<void> deleteNursingIssue(int issueId);

  Future<List<ProfessionalModel>> getProfessionals(String serviceType);
  Future<ProfessionalModel> getProfessionalDetail(String serviceType, int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  final Dio dio;

  NursingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NursingPersonalCaseModel>> getNursingPersonalCases() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_NURSING_PERSONAL_CASES,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final cases = (response.data['data']['data'] as List)
          .map((caseData) => NursingPersonalCaseModel.fromJson(caseData))
          .toList();
      return cases;
    } else {
      throw Exception('Failed to load nursing cases');
    }
  }

  @override
  Future<NursingPersonalCaseModel> createNursingCase(
      NursingPersonalCaseModel nursingCase) async {
    final token = await Utils.getSpString(Const.TOKEN);
    FormData formData = FormData.fromMap(nursingCase.toJson());

    if (nursingCase.images != null) {
      for (File image in nursingCase.images!) {
        formData.files.add(
          MapEntry(
            "images[]",
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }
    }

    final response = await dio.post(
      Const.API_NURSING_PERSONAL_CASES,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return NursingPersonalCaseModel.fromJson(response.data['data']);
  }

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
  Future<void> updateNursingCase(String id, Map<String, dynamic> data) async {
    log('Updating nursing case with id $id and data: $data',
        name: 'NursingRemoteDataSourceImpl');
    final token = await Utils.getSpString(Const.TOKEN);
    final url = '${Const.API_NURSING_PERSONAL_CASES}/$id';
    final payload = FormData.fromMap(data);

    final response = await dio.put(
      url,
      data: payload,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    log('Response status: ${response.statusCode}, data: ${response.data}',
        name: 'NursingRemoteDataSourceImpl');

    if (response.statusCode != 200) {
      throw Exception('Failed to update issue: ${response.statusMessage}');
    }
  }

  @override
  Future<List<ProfessionalModel>> getProfessionals(String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      _getProfessionalEndpoint(serviceType),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final professionals = response.data['data'] as List;
      return professionals
          .map((prof) => ProfessionalModel.fromJson(prof))
          .toList();
    } else {
      log('Error fetching professionals: ${response.statusCode} - ${response.data}',
          name: 'NursingRemoteDataSourceImpl');
      throw Exception('Failed to load professionals');
    }
  }

  @override
  Future<ProfessionalModel> getProfessionalDetail(
      String serviceType, int id) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final response = await dio.get(
      '${_getProfessionalEndpoint(serviceType)}/$id',
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

  String _getProfessionalEndpoint(String serviceType) {
    if (serviceType.toLowerCase() == "pharma" ||
        serviceType.toLowerCase() == "pharmacist") {
      return Const.API_PHARMACIST_SERVICES;
    } else if (serviceType.toLowerCase() == "nurse" ||
        serviceType.toLowerCase() == "specialized_nurse") {
      return Const.API_NURSE_SERVICES;
    } else if (serviceType.toLowerCase() == "radiologist") {
      return Const.API_RADIOLOGIST_SERVICES;
    } else {
      throw Exception('Unknown service type: $serviceType');
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
  Future<void> deleteNursingIssue(int issueId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.delete(
      '${Const.API_NURSING_PERSONAL_CASES}/$issueId',
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
