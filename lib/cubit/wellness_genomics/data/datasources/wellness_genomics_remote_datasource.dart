import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/wellness_genomics/data/models/wellness_genomics_model.dart';

abstract class WellnessGenomicsRemoteDataSource {
  Future<List<WellnessGenomicsModel>> getWellnessGenomics();
  Future<void> storeWellnessGenomics({
    WellnessGenomicsModel? data,
    File? fullReportFile,
    ProgressCallback? onSendProgress,
  });
  Future<void> deleteWellnessGenomic(int id);
}
