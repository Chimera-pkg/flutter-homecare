import 'dart:io';
import 'package:m2health/features/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class StorePharmacogenomics {
  final PharmacogenomicsRepository repository;

  StorePharmacogenomics(this.repository);

  Future<void> call({
    Pharmacogenomics? pharmacogenomics,
    File? fullReportFile,
    Function(double progress)? onProgress,
  }) async {
    await repository.storePharmacogenomics(
      pharmacogenomics: pharmacogenomics,
      fullReportFile: fullReportFile,
      onProgress: onProgress,
    );
  }
}
