import 'package:m2health/core/data/models/personal_case.dart';
import 'package:m2health/core/data/models/payment.dart';
import 'package:m2health/core/data/models/profile.dart';
import 'package:m2health/core/data/models/provider.dart';

class Appointment {
  final int id;
  final String type;
  final String status;
  final String date;
  final String hour;
  final String summary;
  final double payTotal;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final Provider? provider;
  final PersonalCase? personalCase;
  final Payment? payment;
  final Profile? patient;

  Appointment({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.hour,
    required this.summary,
    required this.payTotal,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.provider,
    this.personalCase,
    this.payment,
    this.patient,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'] ?? 0,
        type: json['type'] ?? '',
        status: json['status'] ?? '',
        date: json['date'] ?? '',
        hour: json['hour'] ?? '',
        summary: json['summary'] ?? '',
        payTotal:
            double.tryParse(json['pay_total']?.toString() ?? '0.0') ?? 0.0,
        userId: json['user_id'] ?? 0,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        provider: json['provider'] != null
            ? Provider.fromJson(json['provider'])
            : null,
        personalCase: json['personalCase'] != null
            ? PersonalCase.fromJson(json['personalCase'])
            : null,
        payment:
            json['payment'] != null ? Payment.fromJson(json['payment']) : null,
        patient:
            json['patient'] != null ? Profile.fromJson(json['patient']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'date': date,
      'hour': hour,
      'summary': summary,
      'pay_total': payTotal,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      // Note: provider, personalCase, and payment are not serialized back
      // as they are typically received from the API, not sent.
    };
  }

  Appointment copyWith({
    int? id,
    String? type,
    String? status,
    String? date,
    String? hour,
    String? summary,
    double? payTotal,
    int? userId,
    String? createdAt,
    String? updatedAt,
    Provider? provider,
    PersonalCase? personalCase,
    Payment? payment,
    Profile? patient,
  }) {
    return Appointment(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      summary: summary ?? this.summary,
      payTotal: payTotal ?? this.payTotal,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      provider: provider ?? this.provider,
      personalCase: personalCase ?? this.personalCase,
      payment: payment ?? this.payment,
      patient: patient ?? this.patient,
    );
  }
}
