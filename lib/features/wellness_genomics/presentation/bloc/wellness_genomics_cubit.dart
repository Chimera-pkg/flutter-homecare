import 'dart:developer';
import 'dart:io';
import 'package:m2health/features/wellness_genomics/domain/usecases/delete_wellness_genomic.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/wellness_genomics/domain/usecases/store_wellness_genomics.dart';
import 'package:m2health/features/wellness_genomics/domain/usecases/get_wellness_genomics.dart';
import 'package:m2health/features/wellness_genomics/presentation/bloc/wellness_genomics_state.dart';

class WellnessGenomicsCubit extends Cubit<WellnessGenomicsState> {
  final GetWellnessGenomics getWellnessGenomics;
  final StoreWellnessGenomics storeWellnessGenomics;
  final DeleteWellnessGenomic deleteWellnessGenomic;

  WellnessGenomicsCubit({
    required this.getWellnessGenomics,
    required this.storeWellnessGenomics,
    required this.deleteWellnessGenomic,
  }) : super(const WellnessGenomicsEmpty());

  Future<void> fetchWellnessGenomics() async {
    log('fetchWellnessGenomics() called', name: 'WellnessGenomicsCubit');
    try {
      emit(WellnessGenomicsLoading(data: state.data));
      final optionResult = await getWellnessGenomics();
      log('fetchWellnessGenomics() result:\n $optionResult',
          name: 'WellnessGenomicsCubit');
      optionResult.fold(
        () => emit(const WellnessGenomicsEmpty()),
        (data) => emit(WellnessGenomicsReady(data: data)),
      );
    } catch (e) {
      log('fetchWellnessGenomics() error: $e',
          name: 'WellnessGenomicsCubit', error: e);
      emit(WellnessGenomicsError(data: state.data, message: e.toString()));
    }
  }

  Future<void> uploadReport(File file) async {
    if (state is! WellnessGenomicsEmpty) return;

    final fileName = p.basename(file.path);
    try {
      log('Uploading report: $fileName', name: 'WellnessGenomicsCubit');
      emit(WellnessGenomicsUploading(
        data: state.data,
        progress: 0.0,
        fileName: fileName,
      ));

      await storeWellnessGenomics(
        fullReportFile: file,
        onProgress: (progress) {
          emit(WellnessGenomicsUploading(
            data: state.data,
            progress: progress,
            fileName: fileName,
          ));
        },
      );

      await fetchWellnessGenomics();
    } catch (e) {
      emit(WellnessGenomicsError(data: state.data, message: e.toString()));
    }
  }

  Future<void> delete() async {
    if (state is! WellnessGenomicsReady) return;
    if (state.data.id == null) return;
    try {
      await deleteWellnessGenomic(state.data.id!);
      fetchWellnessGenomics();
    } catch (e) {
      emit(WellnessGenomicsError(data: state.data, message: e.toString()));
    }
  }
}
