import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

abstract class PharmacogenomicsRepository {
  Future<Option<Pharmacogenomics>> getPharmacogenomics();
  Future<void> storePharmacogenomics({
    Pharmacogenomics? pharmacogenomics, 
    File? fullReportFile,
    Function(double progress)? onProgress,
  });
  Future<void> deletePharmacogenomic(int id);
}
