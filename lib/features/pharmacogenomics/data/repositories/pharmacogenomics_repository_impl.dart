import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/features/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/features/pharmacogenomics/data/models/pharmacogenomics_model.dart';
import 'package:m2health/features/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class PharmacogenomicsRepositoryImpl implements PharmacogenomicsRepository {
  final PharmacogenomicsRemoteDataSource remoteDataSource;

  PharmacogenomicsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Option<Pharmacogenomics>> getPharmacogenomics() async {
    log('Fetching pharmacogenomics', name: 'PharmacogenomicsRepository');
    final result = await remoteDataSource.getPharmacogenomics();
    if (result.isEmpty) {
      log('No pharmacogenomics data found', name: 'PharmacogenomicsRepository');
      return const None();
    } else {
      log('Pharmacogenomics data fetched successfully',
          name: 'PharmacogenomicsRepository');
      return Some(result.first);
    }
  }

  @override
  Future<void> storePharmacogenomics({
    Pharmacogenomics? pharmacogenomics,
    File? fullReportFile,
    Function(double progress)? onProgress,
  }) async {
    print('[DEBUG] Repository: storing pharmacogenomics');
    final pharmacogenomicsModel = pharmacogenomics == null
        ? null
        : PharmacogenomicsModel.fromEntity(pharmacogenomics);

    void onSendProgress(int sent, int total) {
      if (onProgress != null && total != 0) {
        final progress = sent / total;
        onProgress(progress);
      }
    }

    await remoteDataSource.storePharmacogenomics(
      data: pharmacogenomicsModel,
      fullReportFile: fullReportFile,
      onSendProgress: onSendProgress,
    );
  }

  @override
  Future<void> deletePharmacogenomic(int id) async {
    await remoteDataSource.deletePharmacogenomic(id);
  }
}
