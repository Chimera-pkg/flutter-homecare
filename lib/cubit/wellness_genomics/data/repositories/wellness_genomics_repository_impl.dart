import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m2health/cubit/wellness_genomics/data/datasources/wellness_genomics_remote_datasource.dart';
import 'package:m2health/cubit/wellness_genomics/data/models/wellness_genomics_model.dart';
import 'package:m2health/cubit/wellness_genomics/domain/entities/wellness_genomics.dart';
import 'package:m2health/cubit/wellness_genomics/domain/repositories/wellness_genomics_repository.dart';

class WellnessGenomicsRepositoryImpl implements WellnessGenomicsRepository {
  final WellnessGenomicsRemoteDataSource remoteDataSource;

  WellnessGenomicsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Option<WellnessGenomics>> getWellnessGenomics() async {
    log('Fetching wellness genomics', name: 'WellnessGenomicsRepository');
    final result = await remoteDataSource.getWellnessGenomics();
    if (result.isEmpty) {
      log('No wellness genomics data found',
          name: 'WellnessGenomicsRepository');
      return const None();
    } else {
      log('WellnessGenomics data fetched successfully',
          name: 'WellnessGenomicsRepository');
      return Some(result.first);
    }
  }

  @override
  Future<void> storeWellnessGenomics({
    WellnessGenomics? wellnessGenomics,
    File? fullReportFile,
    Function(double progress)? onProgress,
  }) async {
    print('[DEBUG] Repository: storing wellness genomics');
    final wellnessGenomicsModel = wellnessGenomics == null
        ? null
        : WellnessGenomicsModel.fromEntity(wellnessGenomics);

    void onSendProgress(int sent, int total) {
      if (onProgress != null && total != 0) {
        final progress = sent / total;
        onProgress(progress);
      }
    }

    await remoteDataSource.storeWellnessGenomics(
      data: wellnessGenomicsModel,
      fullReportFile: fullReportFile,
      onSendProgress: onSendProgress,
    );
  }

  @override
  Future<void> deleteWellnessGenomic(int id) async {
    await remoteDataSource.deleteWellnessGenomic(id);
  }
}
