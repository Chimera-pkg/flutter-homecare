import 'package:dartz/dartz.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/home_health_screening/data/datasources/home_health_screening_remote_datasource.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';

class HomeHealthScreeningRepositoryImpl implements HomeHealthScreeningRepository {
  final HomeHealthScreeningRemoteDatasource remoteDatasource;
  final AppointmentService appointmentService;

  HomeHealthScreeningRepositoryImpl({
    required this.remoteDatasource,
    required this.appointmentService,
  });

  @override
  Future<Either<Failure, List<ScreeningCategory>>> getScreeningServices() async {
    try {
      final result = await remoteDatasource.getScreeningServices();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateScreeningAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'provider_type': params.providerType,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'pay_total': params.payTotal,
        'screening_request_data': {
          'screening_services_ids': params.selectedItems.map((e) => e.id).toList(),
        },
      };

      final response = await appointmentService.createAppointment(payload);
      final result = AppointmentModel.fromJson(response);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}