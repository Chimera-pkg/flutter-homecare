import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';

abstract class AddOnServiceRepository {
  Future<Either<Failure, List<AddOnService>>> getAddOnServices(String serviceType);
}