import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/data/models/appointment_model.dart';
import 'package:m2health/features/nursing/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/nursing/domain/usecases/create_nursing_appointment.dart';

class NursingAppointmentRepositoryImpl extends NursingAppointmentRepository {
  final AppointmentService appointmentService;

  NursingAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNursingAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'provider_type': params.providerType,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'pay_total': params.payTotal,
        'nursing_request_data': {
          'mobility_status': params.nursingCase.mobilityStatus,
          'related_health_record_id': params.nursingCase.relatedHealthRecordId,
          'add_on_service_ids': params.nursingCase.addOnServices
              .map((service) => service.id)
              .toList(),
          'personal_issue_ids':
              params.nursingCase.issues.map((issue) => issue.id).toList(),
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
