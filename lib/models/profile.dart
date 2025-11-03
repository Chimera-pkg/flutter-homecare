class Profile {
  final int id;
  final int userId;
  final int age;
  final double weight;
  final double height;
  final String phoneNumber;
  final String name;
  final String drugAllergy;
  final String homeAddress;
  final String gender;
  final String avatar; // Add this field
  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.age,
    required this.weight,
    required this.height,
    required this.phoneNumber,
    required this.name,
    required this.drugAllergy,
    required this.homeAddress,
    required this.gender,
    required this.avatar, // Add this parameter
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      age: json['age'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'] ?? '',
      drugAllergy: json['drug_allergy'] ?? '',
      homeAddress: json['home_address'] ?? '',
      gender: json['gender'] ?? '',
      avatar: json['avatar'] ?? '', // Add this line
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'age': age,
      'weight': weight,
      'height': height,
      'phone_number': phoneNumber,
      'name': name,
      'drug_allergy': drugAllergy,
      'home_address': homeAddress,
      'gender': gender,
      'avatar': avatar, // Add this line
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Profile copyWith({
    int? id,
    int? userId,
    int? age,
    double? weight,
    double? height,
    String? phoneNumber,
    String? name,
    String? drugAllergy,
    String? homeAddress,
    String? gender,
    String? avatar,
    String? createdAt,
    String? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      drugAllergy: drugAllergy ?? this.drugAllergy,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
