import 'dart:convert';
import 'dart:io';

import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';

class NursingPersonalCaseModel extends NursingCase {
  const NursingPersonalCaseModel({
    super.appointmentId,
    required super.issues,
    super.mobilityStatus,
    super.relatedHealthRecordId,
    required super.addOnServices,
  });

  factory NursingPersonalCaseModel.fromJson(Map<String, dynamic> json) {
    return NursingPersonalCaseModel(
      appointmentId: json['appointment_id'],
      issues: json['personal_issues'] != null
          ? (json['personal_issues'] as List)
              .map((issue) => PersonalIssueModel.fromJson(issue))
              .toList()
          : [],
      mobilityStatus: json['mobility_status'] != null
          ? MobilityStatus.fromApiValue(json['mobility_status'])
          : null,
      relatedHealthRecordId: json['related_health_record_id'],
      addOnServices: json['add_on_services'] != null
          ? (json['add_on_services'] as List)
              .map((addon) => AddOnServiceModel.fromJson(addon))
              .toList()
          : [],
    );
  }







  //  ======== Old Code ========
  // final int? id;
  // final int? appointmentId;
  // final String title;
  // final String? description;
  // final String? mobilityStatus;
  // final String? careType;
  // final List<AddOnService> addOn;
  // final double? estimatedBudget;
  // final int? relatedHealthRecordId;
  // final List<File>? images;
  // final List<String>? imageUrls;
  // final DateTime? createdAt;
  // final DateTime? updatedAt;

  // NursingPersonalCaseModel({
  //   this.id,
  //   this.appointmentId,
  //   required this.title,
  //   this.description,
  //   this.mobilityStatus,
  //   this.careType,
  //   this.addOn = const [],
  //   this.estimatedBudget,
  //   this.relatedHealthRecordId,
  //   this.images,
  //   this.imageUrls,
  //   this.createdAt,
  //   this.updatedAt,
  // });

  // factory NursingPersonalCaseModel.fromJson(Map<String, dynamic> json) {
  //   return NursingPersonalCaseModel(
  //     id: json['id'],
  //     appointmentId: json['appointment_id'],
  //     title: json['title'],
  //     description: json['description'],
  //     mobilityStatus: json['mobility_status'],
  //     careType: json['care_type'],
  //     addOn: json['add_on'] != null
  //         ? (json['add_on'] as List)
  //             .map((addon) => AddOnServiceModel.fromJson(addon))
  //             .toList()
  //         : [],
  //     estimatedBudget:
  //         double.tryParse(json['estimated_budget']?.toString() ?? '') ?? 0.0,
  //     relatedHealthRecordId: json['related_health_record_id'],
  //     imageUrls: json['images'] != null
  //         ? List<String>.from(jsonDecode(json['images']))
  //         : null,
  //     createdAt: DateTime.tryParse(json['created_at'] ?? ''),
  //     updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {
  //     'id': id,
  //     'appointment_id': appointmentId,
  //     'title': title,
  //     'description': description,
  //     'mobility_status': mobilityStatus,
  //     'care_type': careType,
  //     'add_on_ids': addOn.map((e) => e.id).toList(),
  //     'estimated_budget': estimatedBudget,
  //     'related_health_record_id': relatedHealthRecordId,
  //   };
  //   data.removeWhere((key, value) => value == null);

  //   return data;
  // }

  // // Dirty conversion method to transform model to entity
  // // The issues list should be constructed outside this method
  // // as this model represents a single issue
  // NursingCase toEntity() {
  //   return NursingCase(
  //     appointmentId: appointmentId,
  //     careType: careType ?? '',
  //     mobilityStatus: MobilityStatus.fromApiValue(mobilityStatus),
  //     relatedHealthRecordId: relatedHealthRecordId ?? 0,
  //     addOnServices: addOn,
  //     estimatedBudget: estimatedBudget ?? 0.0,
  //     issues: const [],
  //   );
  // }

  // factory NursingPersonalCaseModel.fromEntity(NursingCase nursingCase) {
  //   // This method assumes that the NursingCase contains at least one issue
  //   final firstIssue =
  //       nursingCase.issues.isNotEmpty ? nursingCase.issues.first : null;
  //   return NursingPersonalCaseModel(
  //     appointmentId: nursingCase.appointmentId,
  //     title: firstIssue?.title ?? '',
  //     description: firstIssue?.description,
  //     mobilityStatus: nursingCase.mobilityStatus?.apiValue,
  //     careType: nursingCase.careType,
  //     addOn: nursingCase.addOnServices,
  //     estimatedBudget: nursingCase.estimatedBudget,
  //     relatedHealthRecordId: nursingCase.relatedHealthRecordId,
  //     images: firstIssue?.images,
  //   );
  // }
}
