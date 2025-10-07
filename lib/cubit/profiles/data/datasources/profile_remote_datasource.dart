import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/data/models/profile_model.dart';
import 'package:m2health/utils.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(Map<String, dynamic> profile, File? avatar);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDatasourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get(
        Const.API_PROFILE,
        options: Options(headers: {
          'Authorization': 'Bearer ${await Utils.getSpString(Const.TOKEN)}'
        }),
      );
      final data = response.data['data'];
      log('Profile data received: $data', name: 'ProfileRemoteDatasourceImpl');
      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure("User is not authenticated");
      }
      throw Exception('Failed to load profile data. Error: ${e.message}');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> profile, File? avatar) async {
    try {
      final formData = FormData();

      profile.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (avatar != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
        ));
      }

      await dio.put(
        Const.API_PROFILE,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await Utils.getSpString(Const.TOKEN)}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update profile data. Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
