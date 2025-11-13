import 'package:equatable/equatable.dart';

sealed class Failure with EquatableMixin implements Exception {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
