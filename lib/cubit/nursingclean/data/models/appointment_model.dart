import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';
import 'package:intl/intl.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.id,
    super.userId,
    required super.type,
    required super.status,
    required super.date,
    required super.hour,
    required super.summary,
    required super.payTotal,
    required super.profileServicesData,
    required super.createdAt,
    required super.updatedAt,
    super.providerId,
    super.providerType,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> appointmentJson,
      {Map<String, dynamic>? providerJson}) {
    return AppointmentModel(
      id: appointmentJson['id'],
      userId: appointmentJson['user_id'],
      type: appointmentJson['type'],
      status: appointmentJson['status'],
      date: DateTime.parse(appointmentJson['date']),
      hour: appointmentJson['hour'],
      summary: appointmentJson['summary'] ?? '',
      payTotal: (appointmentJson['pay_total'] as num).toDouble(),
      profileServicesData: appointmentJson['profile_services_data'] ?? <String, dynamic>{},
      createdAt: DateTime.parse(appointmentJson['created_at']),
      updatedAt: DateTime.parse(appointmentJson['updated_at']),
      providerId: providerJson?['id'],
      providerType: providerJson?['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'status': status,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'hour': hour,
      'summary': summary,
      'pay_total': payTotal,
      'profile_services_data': profileServicesData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'provider_id': providerId,
      'provider_type': providerType,
    };
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      status: entity.status,
      date: entity.date,
      hour: entity.hour,
      summary: entity.summary,
      payTotal: entity.payTotal,
      profileServicesData: entity.profileServicesData,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      providerId: entity.providerId,
      providerType: entity.providerType,
    );
  }
}
