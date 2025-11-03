import 'dart:convert';

import 'package:m2health/models/personal_case.dart';
import 'package:m2health/models/payment.dart';

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
  final AppointmentProvider? provider;
  final PersonalCase? personalCase;
  final Payment? payment;

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
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      summary: json['summary'] ?? '',
      // Handle payTotal being a String or num
      payTotal: double.tryParse(json['payTotal']?.toString() ?? '0.0') ?? 0.0,
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      provider: json['provider'] != null
          ? AppointmentProvider.fromJson(json['provider'])
          : null,
      personalCase: json['personalCase'] != null
          ? PersonalCase.fromJson(json['personalCase'])
          : null,
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
    );
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
    AppointmentProvider? provider,
    PersonalCase? personalCase,
    Payment? payment,
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
    );
  }
}

class AppointmentProvider {
  final int id;
  final String name;
  final String? avatar;
  final String? jobTitle;
  final String? role;

  AppointmentProvider({
    required this.id,
    required this.name,
    this.avatar,
    this.jobTitle,
    this.role,
  });

  factory AppointmentProvider.fromJson(Map<String, dynamic> json) {
    return AppointmentProvider(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Provider',
      avatar: json['avatar'],
      jobTitle: json['jobTitle'],
      role: json['role'],
    );
  }
}
