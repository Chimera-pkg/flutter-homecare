class PharmacistServices {
  final int id;
  final String name;
  final String avatar;
  final int experience;
  final int rating;
  final String about;
  final String workingInformation;
  final String daysHour;
  final String mapsLocation;
  final String certification;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PharmacistServices({
    required this.id,
    required this.name,
    required this.avatar,
    required this.experience,
    required this.rating,
    required this.about,
    required this.workingInformation,
    required this.daysHour,
    required this.mapsLocation,
    required this.certification,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PharmacistServices.fromJson(Map<String, dynamic> json) {
    return PharmacistServices(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      experience: json['experience'],
      rating: json['rating'],
      about: json['about'],
      workingInformation: json['working_information'],
      daysHour: json['days_hour'],
      mapsLocation: json['maps_location'],
      certification: json['certification'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'experience': experience,
      'rating': rating,
      'about': about,
      'working_information': workingInformation,
      'days_hour': daysHour,
      'maps_location': mapsLocation,
      'certification': certification,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
