import 'dart:io';
import 'package:m2health/features/pharmacist/domain/entities/pharmacist_case.dart';

class PharmacistCaseModel extends PharmacistCase {
  const PharmacistCaseModel({
    required String title,
    required String description,
    required List<File> images,
  }) : super(
          title: title,
          description: description,
          images: images,
        );

  factory PharmacistCaseModel.fromJson(Map<String, dynamic> json) {
    return PharmacistCaseModel(
      title: json['title'],
      description: json['description'],
      images: [], // Assuming images are not part of the initial fetch
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      // Images are handled separately, likely as multipart upload
    };
  }
}
