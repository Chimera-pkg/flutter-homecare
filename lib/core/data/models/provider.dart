class Provider {
  final int id;
  final String name;
  final String avatar;
  final int experience;
  final double rating;
  final String about;
  final String workingInformation;
  final String workingHours;
  final String workplace;
  final String jobTitle;
  final int userId;
  final String providerType; // 'pharmacist' or 'nurse'
  final DateTime createdAt;
  final DateTime updatedAt;

  Provider({
    required this.id,
    required this.name,
    required this.avatar,
    required this.experience,
    required this.rating,
    required this.about,
    required this.workingInformation,
    required this.workingHours,
    required this.workplace,
    required this.jobTitle,
    required this.userId,
    required this.providerType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method to convert Provider to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'experience': experience,
      'rating': rating,
      'about': about,
      'working_information': workingInformation,
      'working_hours': workingHours,
      'workplace': workplace,
      'job_title': jobTitle,
      'userId': userId,
      'provider_type': providerType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Factory method to create Provider from JSON
  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatar: json['avatar'] ?? '',
      experience: json['experience'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      about: json['about'] ?? 'No information available',
      workingInformation: json['working_information'] ?? 'Not provided',
      workingHours: json['working_hours'] ?? 'Not specified',
      workplace: json['workplace'] ?? 'Unknown',
      jobTitle: json['job_title'] ?? 'Not specified',
      userId: json['userId'] ?? 0,
      providerType: json['provider_type'] ?? 'Unknown',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Method to display provider details
  @override
  String toString() {
    return 'Provider(id: $id, name: $name, jobTitle: $jobTitle, rating: $rating, providerType: $providerType)';
  }
}
