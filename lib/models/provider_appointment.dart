class ProviderAppointment {
  final int id;
  final int userId;
  final String type;
  final String status;
  final String date;
  final String hour;
  final String summary;
  final double payTotal;
  final String providerType;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> profileServiceData;
  final Map<String, dynamic>? personalCase;
  final String createdAt;
  final String updatedAt;

  ProviderAppointment({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.date,
    required this.hour,
    required this.summary,
    required this.payTotal,
    required this.providerType,
    required this.patientData,
    required this.profileServiceData,
    this.personalCase,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderAppointment.fromJson(Map<String, dynamic> json) {
    // Debug: Print raw JSON data
    print('=== ProviderAppointment DEBUG ===');
    print('Raw JSON: $json');
    print('JSON Keys: ${json.keys.toList()}');

    // Check for different possible patient data fields
    final possiblePatientFields = [
      'patient_data',
      'patient',
      'user',
      'profile',
      'patient_info',
      'user_data'
    ];

    Map<String, dynamic> patientData = {};

    for (String field in possiblePatientFields) {
      if (json.containsKey(field) && json[field] != null) {
        print('Found patient data in field: $field');
        print('Patient data: ${json[field]}');
        patientData = Map<String, dynamic>.from(json[field]);
        break;
      }
    }

    // If still empty, try to extract from user relation
    if (patientData.isEmpty && json['user_id'] != null) {
      print(
          'Patient data empty, will need to fetch separately for user_id: ${json['user_id']}');
    }

    print('Final patient data: $patientData');
    print('=== END ProviderAppointment DEBUG ===');

    return ProviderAppointment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      hour: json['hour'] ?? '',
      summary: json['summary'] ?? '',
      payTotal: double.tryParse(json['pay_total']?.toString() ?? '') ?? 0.0,
      providerType: json['provider_type'] ?? '',
      patientData: patientData,
      profileServiceData: json['profile_services_data'] ?? {},
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  ProviderAppointment copyWith({
    String? status,
    // other fields as needed
  }) {
    return ProviderAppointment(
      id: id,
      userId: userId,
      type: type,
      status: status ?? this.status,
      date: date,
      hour: hour,
      summary: summary,
      payTotal: payTotal,
      providerType: providerType,
      patientData: patientData,
      profileServiceData: profileServiceData,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
