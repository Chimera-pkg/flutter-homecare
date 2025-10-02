import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/medical_record/data/model/medical_record_model.dart';
import 'package:m2health/utils.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<List<MedicalRecordModel>> getMedicalRecords();
}

class MedicalRecordRemoteDataSourceImpl
    implements MedicalRecordRemoteDataSource {
  final Dio dio;

  MedicalRecordRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MedicalRecordModel>> getMedicalRecords() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_MEDICAL_RECORDS,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final data = response.data['data'] as List;
    return data.map((json) => MedicalRecordModel.fromJson(json)).toList();
  }
}
