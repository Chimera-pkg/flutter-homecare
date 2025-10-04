class PersonalCase {
  final int id;
  final String title;
  final String description;
  final List<String> images; // Change to list of strings
  final String mobilityStatus;
  // final String relatedHealthRecord;
  final Map<String, dynamic> relatedHealthRecord;
  final String addOn;
  final double estimatedBudget;
  final int userId;

  PersonalCase({
    required this.id,
    required this.title,
    required this.description,
    required this.images, // Change to list of strings
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.userId,
  });

  factory PersonalCase.fromJson(Map<String, dynamic> json) {
    return PersonalCase(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] is String
          ? [json['images']]
          : List<String>.from(json['images'] ?? []),
      mobilityStatus: json['mobility_status'] ?? '',
      // relatedHealthRecord: json['related_health_record'] ?? '',
      relatedHealthRecord: json['related_health_record'] is Map
          ? Map<String, dynamic>.from(json['related_health_record'])
          : {},
      addOn: json['add_on'] ?? '',
      estimatedBudget: double.tryParse(json['estimated_budget']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images, // Change to list of strings
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord,
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'user_id': userId,
    };
  }
}
