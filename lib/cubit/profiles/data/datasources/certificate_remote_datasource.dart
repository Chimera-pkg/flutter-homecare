import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:path/path.dart' as p;

abstract class CertificateRemoteDatasource {
  Future<void> createCertificate(Map<String, dynamic> data, File file);
  Future<void> updateCertificate(int id, Map<String, dynamic> data, File? file);
  Future<void> deleteCertificate(int id);
}

class CertificateRemoteDatasourceImpl implements CertificateRemoteDatasource {
  final Dio dio;

  CertificateRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<void> createCertificate(Map<String, dynamic> data, File file) async {
    try {
      final formData = FormData();

      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      formData.files.add(MapEntry(
        'certificate_file',
        await MultipartFile.fromFile(file.path, filename: (file.path)),
      ));

      await dio.post(
        Const.API_CERTIFICATES,
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('${e.response}. ${e.message}',
          name: 'CertificateRemoteDatasourceImpl', error: e.error);
      throw Exception('Failed to create certificate');
    }
  }

  @override
  Future<void> updateCertificate(
      int id, Map<String, dynamic> data, File? file) async {
    try {
      final formData = FormData();

      data.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (file != null) {
        formData.files.add(MapEntry(
          'certificate_file',
          await MultipartFile.fromFile(file.path,
              filename: p.basename(file.path)),
        ));
      }

      await dio.put(
        '${Const.API_CERTIFICATES}/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('${e.response}. ${e.message}',
          name: 'CertificateRemoteDatasourceImpl', error: e.error);
      throw Exception('Failed to update certificate');
    }
  }

  @override
  Future<void> deleteCertificate(int id) async {
    try {
      await dio.delete(
        '${Const.API_CERTIFICATES}/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      log('${e.response}. ${e.message}',
          name: 'CertificateRemoteDatasourceImpl', error: e.error);
      throw Exception('Failed to delete certificate');
    }
  }
}
