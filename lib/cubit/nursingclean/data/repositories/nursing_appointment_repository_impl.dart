import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/data/models/appointment_model.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/services/appointment_service.dart';

class NursingAppointmentRepositoryImpl extends NursingAppointmentRepository {
  final AppointmentService appointmentService;

  NursingAppointmentRepositoryImpl({required this.appointmentService});

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      AppointmentEntity appointment) async {
    try {
      final appointmentData = AppointmentModel.fromEntity(appointment).toJson();
      final response =
          await appointmentService.createAppointment(appointmentData);
      final createdAppointment = AppointmentModel.fromJson(
          response['data']['appointment'],
          providerJson: response['data']['provider']);
      return Right(createdAppointment);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
