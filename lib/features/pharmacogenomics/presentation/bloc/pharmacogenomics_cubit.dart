import 'dart:developer';
import 'dart:io';
import 'package:m2health/features/pharmacogenomics/domain/usecases/delete_pharmacogenomics.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/store_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/presentation/bloc/pharmacogenomics_state.dart';

class PharmacogenomicsCubit extends Cubit<PharmacogenomicsState> {
  final GetPharmacogenomics getPharmacogenomics;
  final StorePharmacogenomics storePharmacogenomics;
  final DeletePharmacogenomic deletePharmacogenomic;

  PharmacogenomicsCubit({
    required this.getPharmacogenomics,
    required this.storePharmacogenomics,
    required this.deletePharmacogenomic,
  }) : super(const PharmacogenomicsEmpty());

  Future<void> fetchPharmacogenomics() async {
    log('fetchPharmacogenomics() called', name: 'PharmacogenomicsCubit');
    try {
      emit(PharmacogenomicsLoading(data: state.data));
      final optionResult = await getPharmacogenomics();
      log('fetchPharmacogenomics() result:\n $optionResult',
          name: 'PharmacogenomicsCubit');
      optionResult.fold(
        () => emit(const PharmacogenomicsEmpty()),
        (data) => emit(PharmacogenomicsReady(data: data)),
      );
    } catch (e) {
      log('fetchPharmacogenomics() error: $e',
          name: 'PharmacogenomicsCubit', error: e);
      emit(PharmacogenomicsError(data: state.data, message: e.toString()));
    }
  }

  Future<void> uploadReport(File file) async {
    if (state is! PharmacogenomicsEmpty) return;

    final fileName = p.basename(file.path);
    try {
      log('Uploading report: $fileName', name: 'PharmacogenomicsCubit');
      emit(PharmacogenomicsUploading(
        data: state.data,
        progress: 0.0,
        fileName: fileName,
      ));

      await storePharmacogenomics(
        fullReportFile: file,
        onProgress: (progress) {
          emit(PharmacogenomicsUploading(
            data: state.data,
            progress: progress,
            fileName: fileName,
          ));
        },
      );

      await fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(data: state.data, message: e.toString()));
    }
  }

  Future<void> delete() async {
    if (state is! PharmacogenomicsReady) return;
    if (state.data.id == null) return;
    try {
      await deletePharmacogenomic(state.data.id!);
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(data: state.data, message: e.toString()));
    }
  }
}
