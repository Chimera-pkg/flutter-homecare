import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';

class CreateScreeningAppointment {
  final HomeHealthScreeningRepository repository;

  CreateScreeningAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateScreeningAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateScreeningAppointmentParams extends Equatable {
  final String type = 'screening';
  final String providerType = 'nurse';
  final int providerId;
  final DateTime startDatetime;
  final List<ScreeningItem> selectedItems;

  String get summary => 'Home Health Screening: ${selectedItems.map((e) => e.name).join(', ')}';
  
  double get payTotal => selectedItems.fold(
      0.0, (previousValue, element) => previousValue + element.price);

  const CreateScreeningAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.selectedItems,
  });

  @override
  List<Object?> get props => [providerId, startDatetime, selectedItems];
}