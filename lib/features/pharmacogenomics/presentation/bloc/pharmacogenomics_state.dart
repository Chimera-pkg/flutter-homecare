import 'package:equatable/equatable.dart';
import 'package:m2health/features/pharmacogenomics/domain/entities/pharmacogenomics.dart';

abstract class PharmacogenomicsState extends Equatable {
  final Pharmacogenomics data;

  const PharmacogenomicsState({this.data = const Pharmacogenomics()});

  @override
  List<Object?> get props => [data];
}

class PharmacogenomicsEmpty extends PharmacogenomicsState {
  const PharmacogenomicsEmpty();
}

class PharmacogenomicsLoading extends PharmacogenomicsState {
  const PharmacogenomicsLoading({required super.data});
}

class PharmacogenomicsUploading extends PharmacogenomicsState {
  final double progress; // 0.0 to 1.0
  final String fileName;

  const PharmacogenomicsUploading({
    required super.data,
    required this.progress,
    required this.fileName,
  });

  @override
  List<Object?> get props => [data, progress, fileName];
}

class PharmacogenomicsReady extends PharmacogenomicsState {
  const PharmacogenomicsReady({required super.data});
}

class PharmacogenomicsError extends PharmacogenomicsState {
  final String message;

  const PharmacogenomicsError({required super.data, required this.message});

  @override
  List<Object?> get props => [data, message];
}
