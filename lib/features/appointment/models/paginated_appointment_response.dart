import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';

class Meta {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
    );
  }
}

class PaginatedAppointmentsResponse {
  final List<AppointmentEntity> appointments;
  final Meta meta;

  PaginatedAppointmentsResponse({
    required this.appointments,
    required this.meta,
  });

  factory PaginatedAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final appointments = data
        .map((item) => AppointmentModel.fromJson(item))
        .cast<AppointmentEntity>()
        .toList();
    final meta = Meta.fromJson(json['meta'] ?? {});
    return PaginatedAppointmentsResponse(
        appointments: appointments, meta: meta);
  }
}
