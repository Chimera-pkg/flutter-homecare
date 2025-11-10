import 'package:equatable/equatable.dart';

class ProviderAvailabilityOverride extends Equatable {
  final int id;
  final DateTime startDatetime;
  final DateTime endDatetime;

  const ProviderAvailabilityOverride({
    required this.id,
    required this.startDatetime,
    required this.endDatetime,
  });

  @override
  List<Object?> get props => [id, startDatetime, endDatetime];
}