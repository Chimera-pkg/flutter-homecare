import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/datasources/add_on_service_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/repositories/add_on_service_repository.dart';

class AddOnServiceRepositoryImpl implements AddOnServiceRepository {
  final AddOnServiceRemoteDatasource remoteDataSource;

  AddOnServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddOnService>>> getAddOnServices(String serviceType) async {
    try {
      final addOnServices =
          await remoteDataSource.getAddOnServices(serviceType);
      return Right(addOnServices);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
