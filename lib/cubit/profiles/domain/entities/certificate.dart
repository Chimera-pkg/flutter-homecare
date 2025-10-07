import 'package:equatable/equatable.dart';

class Certificate extends Equatable {
  final int id;
  final String title;
  final String registrationNumber;
  final String issuedOn;
  final String fileURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Certificate({
    required this.id,
    required this.title,
    required this.registrationNumber,
    required this.issuedOn,
    required this.fileURL,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        title,
        registrationNumber,
        issuedOn,
        fileURL,
        createdAt,
        updatedAt,
      ];
}
