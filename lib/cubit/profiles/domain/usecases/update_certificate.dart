import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/repositories/certificate_repository.dart';

class UpdateCertificate {
  final CertificateRepository repository;

  UpdateCertificate(this.repository);

  Future<Either<Failure, Unit>> call(UpdateCertificateParams params) async {
    return await repository.update(params);
  }
}

class UpdateCertificateParams extends Equatable {
  final int id;
  final String title;
  final String registrationNumber;
  final String issuedOn;
  final File? file; // File is optional on update

  const UpdateCertificateParams({
    required this.id,
    required this.title,
    required this.registrationNumber,
    required this.issuedOn,
    this.file,
  });

  @override
  List<Object?> get props => [id, title, registrationNumber, issuedOn, file];
}
