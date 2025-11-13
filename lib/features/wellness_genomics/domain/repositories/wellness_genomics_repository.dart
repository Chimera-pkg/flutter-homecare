import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/features/wellness_genomics/domain/entities/wellness_genomics.dart';

abstract class WellnessGenomicsRepository {
  Future<Option<WellnessGenomics>> getWellnessGenomics();
  Future<void> storeWellnessGenomics({
    WellnessGenomics? wellnessGenomics,
    File? fullReportFile,
    Function(double progress)? onProgress,
  });
  Future<void> deleteWellnessGenomic(int id);
}
