import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/repositories/certificate_repository.dart';

class DeleteCertificate {
  CertificateRepository repository;

  DeleteCertificate(this.repository);

  Future<Either<Failure, Unit>> call(int certificationId) async {
    return await repository.delete(certificationId);
  }
}
