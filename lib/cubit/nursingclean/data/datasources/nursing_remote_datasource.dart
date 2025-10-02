import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursingclean/data/models/add_on_service_model.dart';
import 'package:m2health/cubit/nursingclean/data/models/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/data/models/nursing_personal_case.dart';
import 'package:m2health/cubit/nursingclean/data/models/nursing_service.dart';
import 'package:m2health/utils.dart';

abstract class NursingRemoteDataSource {
  Future<List<NursingServiceModel>> getNursingServices();
  Future<List<NursingPersonalCaseModel>> getNursingPersonalCases();
  Future<NursingPersonalCaseModel> createNursingCase(
      NursingPersonalCaseModel data);
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getProfessionals(String serviceType);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
  Future<List<AddOnServiceModel>> getAddOnServices();
}

class NursingRemoteDataSourceImpl implements NursingRemoteDataSource {
  final Dio dio;

  NursingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NursingServiceModel>> getNursingServices() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_NURSE_SERVICES,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final services = (response.data['data'] as List)
          .map((service) => NursingServiceModel.fromMap(service))
          .toList();
      return services;
    } else {
      throw Exception('Failed to load nursing services');
    }
  }

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
    final token = await Utils.getSpString(Const.TOKEN);
    final url = '${Const.API_PERSONAL_CASES}/$id';

    final response = await dio.put(
      url,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update issue: ${response.statusMessage}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getProfessionals(
      String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    String apiEndpoint;
    if (serviceType.toLowerCase() == "pharma" ||
        serviceType.toLowerCase() == "pharmacist") {
      apiEndpoint = Const.API_PHARMACIST_SERVICES;
    } else if (serviceType.toLowerCase() == "nurse") {
      apiEndpoint = Const.API_NURSE_SERVICES;
    } else if (serviceType.toLowerCase() == "radiologist") {
      apiEndpoint = Const.API_RADIOLOGIST_SERVICES;
    } else {
      throw Exception('Unknown service type: $serviceType');
    }

    final response = await dio.get(
      apiEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = response.data;
      List<dynamic> professionalList = [];

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          professionalList = responseData['data'] ?? [];
        } else {
          professionalList = [responseData];
        }
      } else if (responseData is List) {
        professionalList = responseData;
      }
      return professionalList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data: HTTP ${response.statusCode}');
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
  Future<List<AddOnServiceModel>> getAddOnServices() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      '${Const.URL_API}/service-titles/nurse',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final services = (response.data['data'] as List)
          .map((service) => AddOnServiceModel.fromJson(service))
          .toList();
      return services;
    } else {
      throw Exception('Failed to load add-on services');
    }
  }
}
