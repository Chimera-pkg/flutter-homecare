import 'dart:io';
import 'package:m2health/cubit/wellness_genomics/domain/entities/wellness_genomics.dart';
import 'package:m2health/cubit/wellness_genomics/domain/repositories/wellness_genomics_repository.dart';

class StoreWellnessGenomics {
  final WellnessGenomicsRepository repository;

  StoreWellnessGenomics(this.repository);

  Future<void> call({
    WellnessGenomics? wellnessGenomics,
    File? fullReportFile,
    Function(double progress)? onProgress,
  }) async {
    await repository.storeWellnessGenomics(
      wellnessGenomics: wellnessGenomics,
      fullReportFile: fullReportFile,
      onProgress: onProgress,
    );
  }
}
