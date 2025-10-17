import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/profiles/domain/usecases/create_certificate.dart';
import 'package:m2health/cubit/profiles/domain/usecases/update_certificate.dart';
import 'package:m2health/cubit/profiles/domain/usecases/delete_certificate.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/certificate_state.dart';


class CertificateCubit extends Cubit<CertificateState> {
  final CreateCertificate createCertificateUseCase;
  final UpdateCertificate updateCertificateUseCase;
  final DeleteCertificate deleteCertificateUseCase;

  CertificateCubit({
    required this.createCertificateUseCase,
    required this.updateCertificateUseCase,
    required this.deleteCertificateUseCase,
  }) : super(CertificateInitial());

  Future<void> addCertificate(CreateCertificateParams params) async {
    emit(CertificateLoading());
    final result = await createCertificateUseCase(params);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (_) => emit(CertificateSuccess('Certificate added successfully!')),
    );
  }

  Future<void> editCertificate(UpdateCertificateParams params) async {
    emit(CertificateLoading());
    final result = await updateCertificateUseCase(params);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (_) => emit(CertificateSuccess('Certificate updated successfully!')),
    );
  }

  Future<void> removeCertificate(int certificateId) async {
    emit(CertificateLoading());
    final result = await deleteCertificateUseCase(certificateId);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (_) => emit(CertificateSuccess('Certificate removed successfully.')),
    );
  }
}