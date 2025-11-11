import 'package:m2health/features/appointment/models/appointment.dart';

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
  final List<Appointment> appointments;
  final Meta meta;

  PaginatedAppointmentsResponse({
    required this.appointments,
    required this.meta,
  });

  factory PaginatedAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final appointments =
        data.map((item) => Appointment.fromJson(item)).toList();
    final meta = Meta.fromJson(json['meta'] ?? {});
    return PaginatedAppointmentsResponse(appointments: appointments, meta: meta);
  }
}
