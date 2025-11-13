import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/wellness_genomics/data/datasources/wellness_genomics_remote_datasource.dart';
import 'package:m2health/features/wellness_genomics/data/models/wellness_genomics_model.dart';
import 'package:m2health/utils.dart';
import 'dart:developer';
import 'package:path/path.dart' as p;

class WellnessGenomicsRemoteDataSourceImpl
    implements WellnessGenomicsRemoteDataSource {
  final Dio dio;

  WellnessGenomicsRemoteDataSourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<WellnessGenomicsModel>> getWellnessGenomics() async {
    try {
      final response = await dio.get(
        Const.API_WELLNESS_GENOMICS,
        options: await _getAuthHeaders(),
      );
      if (response.data is List) {
        return (response.data as List)
            .map((item) =>
                WellnessGenomicsModel.fromJson(item as Map<String, dynamic>))
            .toList()
            .cast<WellnessGenomicsModel>();
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      log('DioException on getWellnessGenomics: ${e.message}',
          name: 'DataSource');
      throw Exception(
          'Failed to fetch wellness genomics data. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on getWellnessGenomics: $e', name: 'DataSource');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> storeWellnessGenomics({
    WellnessGenomicsModel? data,
    File? fullReportFile,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      FormData formData = FormData();

      if (data != null) {
        formData = FormData.fromMap(data.toJson());
      }

      if (fullReportFile != null) {
        final fileName = p.basename(fullReportFile.path);
        formData.files.add(MapEntry(
          'full_path_report',
          await MultipartFile.fromFile(fullReportFile.path, filename: fileName),
        ));
      }

      await dio.post(
        Const.API_WELLNESS_GENOMICS,
        data: formData,
        options: await _getAuthHeaders(),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      log('DioException on createWellnessGenomic: ${e.message}',
          name: 'DataSource');
      throw Exception('Failed to create report. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on createWellnessGenomic: $e', name: 'DataSource');
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<void> deleteWellnessGenomic(int id) async {
    try {
      await dio.delete(
        '${Const.API_WELLNESS_GENOMICS}/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('DioException on deleteWellnessGenomic($id): ${e.message}',
          name: 'DataSource');
      throw Exception('Failed to delete report. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on deleteWellnessGenomic($id): $e',
          name: 'DataSource');
      throw Exception('An unexpected error occurred.');
    }
  }
}
