import 'dart:convert';

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
  final Map<String, dynamic> profileServiceData;

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
    required this.profileServiceData,
  });

  // factory Appointment.fromJson(Map<String, dynamic> json) {
  //   return Appointment(
  //     id: json['id'] ?? 0,
  //     type: json['type'] ?? '',
  //     status: json['status'] ?? '',
  //     date: json['date'] ?? '',
  //     hour: json['hour'] ?? '',
  //     summary: json['summary'] ?? '',
  //     payTotal: (json['pay_total'] as num?)?.toDouble() ?? 0.0,
  //     userId: json['user_id'] ?? 0,
  //     createdAt: json['created_at'] ?? '',
  //     updatedAt: json['updated_at'] ?? '',
  //     // Fix: Handle null profile_services_data properly
  //     profileServiceData: json['profile_services_data'] != null
  //         ? (json['profile_services_data'] is String
  //             ? jsonDecode(json['profile_services_data'])
  //             : json['profile_services_data'])
  //         : <String, dynamic>{}, // Return empty map instead of null
  //   );
  // }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedProfileData = {};

    if (json['profile_services_data'] != null) {
      if (json['profile_services_data'] is String) {
        final raw = json['profile_services_data'].toString().trim();
        if (raw.isNotEmpty) {
          try {
            parsedProfileData = jsonDecode(raw);
          } catch (e) {
            print("Warning: Failed to parse profile_services_data: $e");
            parsedProfileData = {};
          }
        }
      } else if (json['profile_services_data'] is Map<String, dynamic>) {
        parsedProfileData = json['profile_services_data'];
      }
    }

    return Appointment(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      summary: json['summary'] ?? '',
      payTotal: double.tryParse(json['pay_total']?.toString() ?? '') ?? 0.0,
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profileServiceData: parsedProfileData,
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
      'profile_services_data': jsonEncode(profileServiceData),
    };
  }

  /// Extract provider name from summary field
  /// Handles patterns like "Appointment booking with nurse_new"
  String? extractProviderNameFromSummary() {
    if (summary.isEmpty) return null;

    // Look for common patterns
    final patterns = [
      r'appointment booking with\s+([a-zA-Z_][a-zA-Z0-9_]*)',
      r'booking with\s+([a-zA-Z_][a-zA-Z0-9_]*)',
      r'with\s+([a-zA-Z_][a-zA-Z0-9_]*)',
    ];

    for (final pattern in patterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      final match = regex.firstMatch(summary);
      if (match != null && match.group(1) != null) {
        final extractedName = match.group(1)!;
        // Filter out common words that aren't provider names
        if (!['appointment', 'booking', 'with', 'the', 'a', 'an']
            .contains(extractedName.toLowerCase())) {
          return extractedName;
        }
      }
    }

    return null;
  }

  /// Determine provider type from appointment type or summary
  String getProviderType() {
    final typeLower = type.toLowerCase();
    final summaryLower = summary.toLowerCase();

    if (typeLower.contains('nurse') || summaryLower.contains('nurse')) {
      return 'nurse';
    } else if (typeLower.contains('pharmacist') ||
        summaryLower.contains('pharmacist')) {
      return 'pharmacist';
    } else {
      // Default to pharmacist if unclear
      return 'pharmacist';
    }
  }

  /// Check if profile service data is empty or missing essential information
  bool get needsProviderDataFallback {
    if (profileServiceData.isEmpty) return true;

    // Check if essential provider information is missing
    final hasName = profileServiceData['name']?.toString().isNotEmpty == true ||
        profileServiceData['username']?.toString().isNotEmpty == true ||
        profileServiceData['provider_name']?.toString().isNotEmpty == true ||
        profileServiceData['pharmacist_name']?.toString().isNotEmpty == true ||
        profileServiceData['nurse_name']?.toString().isNotEmpty == true;

    return !hasName;
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
    Map<String, dynamic>? profileServiceData,
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
      profileServiceData: profileServiceData ?? this.profileServiceData,
    );
  }
}
