import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/repositories/certificate_repository.dart';

class CreateCertificate {
  CertificateRepository repository;

  CreateCertificate(this.repository);

  Future<Either<Failure, Unit>> call(CreateCertificateParams params) async {
    return await repository.create(params);
  }
}

class CreateCertificateParams extends Equatable {
  final String title;
  final String registrationNumber;
  final String issuedOn;
  final File file;

  const CreateCertificateParams({
    required this.title,
    required this.registrationNumber,
    required this.issuedOn,
    required this.file,
  });

  @override
  List<Object?> get props => [title, registrationNumber, issuedOn, file];
}
