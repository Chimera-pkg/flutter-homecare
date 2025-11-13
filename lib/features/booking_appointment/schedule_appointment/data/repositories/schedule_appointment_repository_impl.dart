import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/repositories/schedule_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/data/datasources/schedule_appointment_remote_datasource.dart';

class ScheduleAppointmentRepositoryImpl implements ScheduleAppointmentRepository {
  final ScheduleAppointmentRemoteDataSource remoteDataSource;

  ScheduleAppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(
      GetAvailableTimeSlotsParams params) async {
    try {
      final remoteSlots = await remoteDataSource.getAvailableTimeSlots(params);
      return Right(remoteSlots);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rescheduleAppointment({
    required int appointmentId,
    required DateTime newTime,
  }) async {
    try {
      await remoteDataSource.rescheduleAppointment(
        appointmentId: appointmentId,
        newTime: newTime,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}