import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomic_report_state.dart';
import 'package:path/path.dart' as p;

class PharmacogenomicReportCubit extends Cubit<PharmacogenomicReportState> {
  PharmacogenomicReportCubit() : super(const PharmacogenomicReportInitial());

  Future<void> fetchReport() async {
    emit(const PharmacogenomicReportLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const PharmacogenomicReportInitial());
  }

  // Simulate file upload with progress updates
  Future<void> uploadReport(File file) async {
    final fileName = p.basename(file.path);

    emit(PharmacogenomicReportUploading(fileName: fileName, progress: 0.0));

    const uploadDuration = Duration(seconds: 1);
    const updateInterval = Duration(milliseconds: 50);
    int steps =
        (uploadDuration.inMilliseconds / updateInterval.inMilliseconds).round();
    for (int i = 0; i < steps; i++) {
      await Future.delayed(updateInterval);
      final progress = (i + 1) / steps;
      emit(PharmacogenomicReportUploading(
          fileName: fileName, progress: progress));
    }

    emit(PharmacogenomicReportReady(
      fileName: fileName,
      fileUrl: 'https://example.com/reports/$fileName',
    ));
  }

  void removeReport() {
    emit(const PharmacogenomicReportInitial());
  }
}
