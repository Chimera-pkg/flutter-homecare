import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/medical_record/data/model/medical_record_model.dart';
import 'package:m2health/features/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/update_medical_record.dart';
import 'package:m2health/utils.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<List<MedicalRecordModel>> getMedicalRecords();
  Future<MedicalRecordModel> createMedicalRecord(CreateRecordParams params);
  Future<MedicalRecordModel> updateMedicalRecord(UpdateRecordParams params);
  Future<void> deleteMedicalRecord(int id);
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

  @override
  Future<void> deleteMedicalRecord(int id) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final String endpoint = '${Const.API_MEDICAL_RECORDS}/$id';

    await dio.delete(
      endpoint,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );
  }

  @override
  Future<MedicalRecordModel> createMedicalRecord(
      CreateRecordParams params) async {
    final token = await Utils.getSpString(Const.TOKEN);

    final Map<String, dynamic> formFields = {
      'title': params.title,
      'disease_name': params.diseaseName,
      'disease_history': params.diseaseHistory,
      'special_consideration': params.specialConsideration ?? '',
      'treatment_info': params.treatmentInfo ?? '',
    };

    if (params.file != null) {
      formFields['file_url'] = await MultipartFile.fromFile(
        params.file!.path,
        filename: params.file!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formFields);

    final response = await dio.post(
      Const.API_MEDICAL_RECORDS,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MedicalRecordModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create medical record');
    }
  }

  @override
  Future<MedicalRecordModel> updateMedicalRecord(
      UpdateRecordParams params) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final String endpoint = '${Const.API_MEDICAL_RECORDS}/${params.id}';

    final Map<String, dynamic> formFields = {
      'title': params.title,
      'disease_name': params.diseaseName,
      'disease_history': params.diseaseHistory,
      'special_consideration': params.specialConsideration ?? '',
      'treatment_info': params.treatmentInfo ?? '',
    };

    if (params.file != null) {
      formFields['file_url'] = await MultipartFile.fromFile(
        params.file!.path,
        filename: params.file!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formFields);

    final response = await dio.put(
      endpoint,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      return MedicalRecordModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update medical record');
    }
  }
}
