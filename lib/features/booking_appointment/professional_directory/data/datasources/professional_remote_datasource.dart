import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/models/professional_model.dart';
import 'package:m2health/utils.dart';

class ProfessionalRemoteDatasource {
  final Dio dio;

  ProfessionalRemoteDatasource(this.dio);

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
          error: e, name: 'ProfessionalRemoteDatasource');
      rethrow;
    }
  }

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
}
