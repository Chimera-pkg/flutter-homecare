import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final int? userId;
  final String type;
  final String status;
  final DateTime date;
  final String hour;
  final String summary;
  final double payTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? providerId;
  final String? providerType;


  const AppointmentEntity({
    this.id,
    this.userId,
    required this.type,
    required this.status,
    required this.date,
    required this.hour,
    required this.summary,
    required this.payTotal,
    required this.createdAt,
    required this.updatedAt,
    this.providerId,
    this.providerType,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        date,
        hour,
        summary,
        payTotal,
        createdAt,
        updatedAt,
        providerId,
        providerType,
      ];
}
