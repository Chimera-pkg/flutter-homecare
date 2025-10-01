import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/cubit/pharmacogenomics/data/models/pharmacogenomics_model.dart';
import 'package:m2health/utils.dart';
import 'dart:developer'; // Menggunakan 'log' untuk debug yang lebih baik

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
  @override
  Future<List<PharmacogenomicsModel>> getPharmacogenomics() async {
    try {
      final response = await dio.get(
        Const.API_PHARMACOGENOMICS,
        options: await _getAuthHeaders(),
      );

      // [SALAH] final dynamic rawData = response.data['data'];
      // [BENAR] Langsung gunakan response.data karena API mengembalikan List secara langsung.
      final dynamic rawData = response.data;

      if (rawData is List) {
        // Mengubah setiap item di list menjadi PharmacogenomicsModel
        return rawData
            .map((item) =>
                PharmacogenomicsModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Jika respons ternyata bukan List, ini adalah error dari sisi API
        throw Exception(
            'API response format is incorrect: Expected a List but got ${rawData.runtimeType}.');
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
  Future<PharmacogenomicsModel> getPharmacogenomicById(int id) async {
    try {
      final response = await dio.get(
        '${Const.API_PHARMACOGENOMICS}/$id',
        options: await _getAuthHeaders(),
      );

      // [FIX] Perbaikan yang sama kemungkinan besar diperlukan di sini.
      // Asumsi API untuk get by ID juga mengembalikan objek JSON secara langsung.
      return PharmacogenomicsModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      log('DioException on getPharmacogenomicById($id): ${e.message}',
          name: 'DataSource');
      throw Exception(
          'Failed to load pharmacogenomic data. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on getPharmacogenomicById($id): $e',
          name: 'DataSource');
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<void> createPharmacogenomic(String gene, String genotype,
      String phenotype, String medicationGuidance) async {
    try {
      final formData = FormData.fromMap({
        'gene': gene,
        'genotype': genotype,
        'phenotype': phenotype,
        'medication_guidance': medicationGuidance,
      });

      await dio.post(
        Const.API_PHARMACOGENOMICS,
        data: formData,
        options: await _getAuthHeaders(),
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
  Future<void> updatePharmacogenomic(int id, String gene, String genotype,
      String phenotype, String medicationGuidance) async {
    try {
      final formData = FormData.fromMap({
        'gene': gene,
        'genotype': genotype,
        'phenotype': phenotype,
        'medication_guidance': medicationGuidance,
        // [FIX] Menggunakan POST dengan _method 'PUT' lebih stabil untuk FormData
        '_method': 'PUT',
      });

      // Menggunakan dio.post karena lebih kompatibel dengan FormData
      await dio.post(
        '${Const.API_PHARMACOGENOMICS}/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('DioException on updatePharmacogenomic($id): ${e.message}',
          name: 'DataSource');
      throw Exception('Failed to update report. Error: ${e.message}');
    } catch (e) {
      log('Unexpected error on updatePharmacogenomic($id): $e',
          name: 'DataSource');
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
