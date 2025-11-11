import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/pharmacist/data/datasources/pharmacist_remote_datasource.dart';
import 'package:m2health/features/pharmacist/data/models/pharmacist_case_model.dart';
import 'package:m2health/utils.dart';

class PharmacistRemoteDataSourceImpl implements PharmacistRemoteDataSource {
  final Dio dio;

  PharmacistRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PharmacistCaseModel>> getPharmacistCases() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_PHARMACIST_PERSONAL_CASES,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final cases = (response.data['data'] as List)
          .map((caseData) => PharmacistCaseModel.fromJson(caseData))
          .toList();
      return cases;
    } else {
      throw Exception('Failed to load pharmacist cases');
    }
  }
}
