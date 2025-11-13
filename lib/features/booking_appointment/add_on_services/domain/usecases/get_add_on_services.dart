import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/repositories/add_on_service_repository.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';

class GetAddOnServices {
  final AddOnServiceRepository repository;

  GetAddOnServices(this.repository);

  Future<Either<Failure, List<AddOnService>>> call(String serviceType) async {
    return await repository.getAddOnServices(serviceType);
  }
}
