import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/utils.dart';

class AddOnServiceRemoteDatasource {
  final Dio dio;

  AddOnServiceRemoteDatasource(this.dio);

  Future<List<AddOnService>> getAddOnServices(String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    log('Fetching add-on services for $serviceType',
        name: 'AddOnServiceRemoteDatasource');

    final response = await dio.get(
      '${Const.URL_API}/service-titles',
      queryParameters: {'service_type': serviceType},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    log('Response data: ${response.data}',
        name: 'AddOnServiceRemoteDatasource');

    final services = (response.data as List)
        .map((service) => AddOnServiceModel.fromJson(service))
        .toList();
    return services;
  }
}
