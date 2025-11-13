abstract class CertificateState {}

class CertificateInitial extends CertificateState {}

class CertificateLoading extends CertificateState {} // Uploading and deleting

class CertificateSuccess extends CertificateState {
  final String message;
  CertificateSuccess(this.message);
}

class CertificateError extends CertificateState {
  final String message;
  CertificateError(this.message);
}