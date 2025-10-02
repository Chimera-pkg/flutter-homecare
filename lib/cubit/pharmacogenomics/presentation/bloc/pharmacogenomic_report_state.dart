import 'package:equatable/equatable.dart';

abstract class PharmacogenomicReportState extends Equatable {
  const PharmacogenomicReportState();
  @override
  List<Object?> get props => [];
}

class PharmacogenomicReportInitial extends PharmacogenomicReportState {
  const PharmacogenomicReportInitial();
}

class PharmacogenomicReportLoading extends PharmacogenomicReportState {
  const PharmacogenomicReportLoading();
}

class PharmacogenomicReportUploading extends PharmacogenomicReportState {
  final String fileName;
  final double progress; // 0.0 to 1.0

  const PharmacogenomicReportUploading(
      {required this.fileName, required this.progress});

  @override
  List<Object?> get props => [fileName, progress];
}

class PharmacogenomicReportReady extends PharmacogenomicReportState {
  final String fileName;
  final String fileUrl;

  const PharmacogenomicReportReady(
      {required this.fileName, required this.fileUrl});

  @override
  List<Object?> get props => [fileName, fileUrl];
}

class PharmacogenomicReportError extends PharmacogenomicReportState {
  final String message;

  const PharmacogenomicReportError(this.message);

  @override
  List<Object?> get props => [message];
}

