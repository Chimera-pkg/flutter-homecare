import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/home_health_screening/data/models/screening_category_model.dart';

class HomeHealthScreeningRemoteDatasource {
  final Dio dio;

  HomeHealthScreeningRemoteDatasource(this.dio);

  Future<List<ScreeningCategoryModel>> getScreeningServices() async {
    final response = await dio.get(
      '${Const.URL_API}/screening-services',
    );

    return (response.data['data'] as List)
        .map((e) => ScreeningCategoryModel.fromJson(e))
        .toList();
  }
}
