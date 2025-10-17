class Profile {
  final int id;
  final int userId;
  final int age;
  final double weight;
  final double height;
  final String phoneNumber;
  final String username;
  final String email;
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
    required this.username,
    required this.email,
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
      username: json['username'] ?? '',
      email: json['email'] ?? '',
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
      'username': username,
      'email': email,
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
    String? username,
    String? email,
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
      username: username ?? this.username,
      email: email ?? this.email,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
