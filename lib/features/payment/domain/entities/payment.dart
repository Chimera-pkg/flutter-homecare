import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final int id;
  final int userId;
  final int appointmentId;
  final String method;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.userId,
    required this.appointmentId,
    required this.method,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        appointmentId,
        method,
        amount,
        status,
        createdAt,
        updatedAt,
      ];
}
