import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/features/pharmacogenomics/data/models/pharmacogenomics_model.dart';
import 'package:m2health/utils.dart';
import 'dart:developer';
import 'package:path/path.dart' as p;

class PharmacogenomicsRemoteDataSourceImpl
    implements PharmacogenomicsRemoteDataSource {
  final Dio dio;

  PharmacogenomicsRemoteDataSourceImpl({required this.dio});

  // Helper untuk membuat header otentikasi
  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<PharmacogenomicsModel>> getPharmacogenomics() async {
    try {
      final response = await dio.get(
        Const.API_PHARMACOGENOMICS,
        options: await _getAuthHeaders(),
      );
      if (response.data is List) {
        return (response.data as List)
            .map((item) =>
                PharmacogenomicsModel.fromJson(item as Map<String, dynamic>))
            .toList()
            .cast<PharmacogenomicsModel>();
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      // [DEBUG] Menampilkan error Dio yang lebih informatif
      log('DioException on getPharmacogenomics: ${e.message}',
          name: 'DataSource');
      throw Exception(
          'Failed to fetch pharmacogenomics data. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on getPharmacogenomics: $e', name: 'DataSource');
      throw Exception(
          'An unexpected error occurred: $e'); // Menambahkan detail error asli
    }
  }

  @override
  Future<void> storePharmacogenomics({
    PharmacogenomicsModel? data,
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
        Const.API_PHARMACOGENOMICS,
        data: formData,
        options: await _getAuthHeaders(),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      log('DioException on createPharmacogenomic: ${e.message}',
          name: 'DataSource');
      throw Exception('Failed to create report. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on createPharmacogenomic: $e', name: 'DataSource');
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<void> deletePharmacogenomic(int id) async {
    try {
      await dio.delete(
        '${Const.API_PHARMACOGENOMICS}/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('DioException on deletePharmacogenomic($id): ${e.message}',
          name: 'DataSource');
      throw Exception('Failed to delete report. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on deletePharmacogenomic($id): $e',
          name: 'DataSource');
      throw Exception('An unexpected error occurred.');
    }
  }
}
