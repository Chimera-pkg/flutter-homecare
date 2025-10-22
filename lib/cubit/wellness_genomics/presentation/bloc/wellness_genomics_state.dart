import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/wellness_genomics/domain/entities/wellness_genomics.dart';

abstract class WellnessGenomicsState extends Equatable {
  final WellnessGenomics data;

  const WellnessGenomicsState({this.data = const WellnessGenomics()});

  @override
  List<Object?> get props => [data];
}

class WellnessGenomicsEmpty extends WellnessGenomicsState {
  const WellnessGenomicsEmpty();
}

class WellnessGenomicsLoading extends WellnessGenomicsState {
  const WellnessGenomicsLoading({required super.data});
}

class WellnessGenomicsUploading extends WellnessGenomicsState {
  final double progress; // 0.0 to 1.0
  final String fileName;

  const WellnessGenomicsUploading({
    required super.data,
    required this.progress,
    required this.fileName,
  });

  @override
  List<Object?> get props => [data, progress, fileName];
}

class WellnessGenomicsReady extends WellnessGenomicsState {
  const WellnessGenomicsReady({required super.data});
}

class WellnessGenomicsError extends WellnessGenomicsState {
  final String message;

  const WellnessGenomicsError({required super.data, required this.message});

  @override
  List<Object?> get props => [data, message];
}
