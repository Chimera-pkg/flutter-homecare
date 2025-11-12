import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/repositories/pharmacy_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';

class PharmacyAppointmentRepositoryImpl extends PharmacyAppointmentRepository {
  final AppointmentService appointmentService;

  PharmacyAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePharmacyAppointmentParams params) async {
    try {
      final payload = {
        'type': params.type,
        'provider_id': params.providerId,
        'provider_type': params.providerType,
        'start_datetime': params.startDatetime.toIso8601String(),
        'summary': params.summary,
        'pay_total': params.payTotal,
        'pharmacy_request_data': {
          'mobility_status': params.pharmacyCase.mobilityStatus?.apiValue,
          'related_health_record_id': params.pharmacyCase.relatedHealthRecordId,
          'add_on_service_ids': params.pharmacyCase.addOnServices
              .map((service) => service.id)
              .toList(),
          'personal_issue_ids':
              params.pharmacyCase.issues.map((issue) => issue.id).toList(),
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
