part of 'pharmacist_profile_cubit.dart';

@immutable
abstract class PharmacistProfileState {}

class PharmacistProfileInitial extends PharmacistProfileState {}

class PharmacistProfileLoaded extends PharmacistProfileState {
  final String name;
  final String role;
  final String patients;
  final String experience;
  final String rating;
  final String about;
  final String workingInfo;
  final List<Certificate> certificates;
  final List<Review> reviews;
  final String imageUrl;

  PharmacistProfileLoaded({
    required this.name,
    required this.role,
    required this.patients,
    required this.experience,
    required this.rating,
    required this.about,
    required this.workingInfo,
    required this.certificates,
    required this.reviews,
    required this.imageUrl,
  });
}

class Certificate {
  final String title;
  final String idNumber;
  final String issued;

  Certificate({
    required this.title,
    required this.idNumber,
    required this.issued,
  });
}

class Review {
  final String reviewer;
  final String text;
  final String rating;

  Review({
    required this.reviewer,
    required this.text,
    required this.rating,
  });
}
