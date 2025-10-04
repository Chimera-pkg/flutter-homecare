import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/pharmacogenomics/data/models/pharmacogenomics_model.dart';

abstract class PharmacogenomicsRemoteDataSource {
  Future<List<PharmacogenomicsModel>> getPharmacogenomics();
  Future<void> storePharmacogenomics({
    PharmacogenomicsModel? data,
    File? fullReportFile,
    ProgressCallback? onSendProgress,
  });
  Future<void> deletePharmacogenomic(int id);
}
