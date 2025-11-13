import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/repositories/certificate_repository.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/data/datasources/certificate_remote_datasource.dart';

class CertificateRepositoryImpl implements CertificateRepository {
  final CertificateRemoteDatasource remoteDatasource;

  CertificateRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Unit>> create(CreateCertificateParams params) async {
    try {
      final data = {
        'certificate_title': params.title,
        'registration_number': params.registrationNumber,
        'issued_on': params.issuedOn,
      };
      await remoteDatasource.createCertificate(data, params.file);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(UpdateCertificateParams params) async {
    try {
      final data = {
        'certificate_title': params.title,
        'registration_number': params.registrationNumber,
        'issued_on': params.issuedOn,
      };
      await remoteDatasource.updateCertificate(params.id, data, params.file);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> delete(int certificationId) async {
    try {
      await remoteDatasource.deleteCertificate(certificationId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
