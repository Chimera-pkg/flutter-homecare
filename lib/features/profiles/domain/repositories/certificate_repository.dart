import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

abstract class CertificateRepository {
  Future<Either<Failure, Unit>> create(CreateCertificateParams params);
  Future<Either<Failure, Unit>> update(UpdateCertificateParams params);
  Future<Either<Failure, Unit>> delete(int certificationId);
}
