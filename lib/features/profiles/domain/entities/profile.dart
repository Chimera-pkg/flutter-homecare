class Profile {
  final int id;
  final int userId;
  final String name;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress;
  final String? gender;
  final String? drugAllergy;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.name,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.drugAllergy,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
    int? id,
    int? userId,
    String? name,
    int? age,
    double? weight,
    double? height,
    String? phoneNumber,
    String? homeAddress,
    String? gender,
    String? drugAllergy,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      drugAllergy: drugAllergy ?? this.drugAllergy,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
