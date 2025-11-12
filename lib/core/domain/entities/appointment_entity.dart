import 'package:equatable/equatable.dart';
import 'package:m2health/core/data/models/payment.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final int? userId;
  final String type;
  final String status;
  final DateTime startDatetime;
  final DateTime? endDatetime;
  final String summary;
  final double payTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? providerId;
  final String? providerType;

  final ProfessionalEntity? provider;
  final NursingCase? nursingCase;
  final PharmacyCase? pharmacyCase;
  final Profile? patientProfile;
  final Payment? payment;

  const AppointmentEntity({
    this.id,
    this.userId,
    required this.type,
    required this.status,
    required this.startDatetime,
    this.endDatetime,
    required this.summary,
    required this.payTotal,
    required this.createdAt,
    required this.updatedAt,
    this.providerId,
    this.providerType,
    this.provider,
    this.nursingCase,
    this.pharmacyCase,
    this.patientProfile,
    this.payment,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        status,
        startDatetime,
        endDatetime,
        summary,
        payTotal,
        createdAt,
        updatedAt,
        providerId,
        providerType,
        provider,
      ];
}
