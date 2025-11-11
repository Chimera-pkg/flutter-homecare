import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/utils.dart';
import 'package:path/path.dart' as p;
import 'package:m2health/const.dart';

// State untuk Precision Nutrition Assessment
class NutritionAssessmentState extends Equatable {
  final int? id;
  final int? userId;
  final String? mainConcern;
  final HealthProfile? healthProfile;
  final double selfRatedHealth;
  final LifestyleHabits? lifestyleHabits;
  final NutritionHabits? nutritionHabits;
  final List<String> fileUrls; // Uploaded file URLs
  final List<File> files; // Files to be uploaded
  final bool isLoading;
  final String? errorMessage;

  bool get isSubmitted => id != null;

  const NutritionAssessmentState({
    this.id,
    this.userId,
    this.mainConcern,
    this.healthProfile,
    this.selfRatedHealth = 1.0,
    this.lifestyleHabits,
    this.nutritionHabits,
    this.fileUrls = const [],
    this.files = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  NutritionAssessmentState copyWith({
    int? id,
    int? userId,
    String? mainConcern,
    HealthProfile? healthProfile,
    double? selfRatedHealth,
    LifestyleHabits? lifestyleHabits,
    NutritionHabits? nutritionHabits,
    List<String>? fileUrls,
    List<File>? files,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NutritionAssessmentState(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mainConcern: mainConcern ?? this.mainConcern,
      healthProfile: healthProfile ?? this.healthProfile,
      selfRatedHealth: selfRatedHealth ?? this.selfRatedHealth,
      lifestyleHabits: lifestyleHabits ?? this.lifestyleHabits,
      nutritionHabits: nutritionHabits ?? this.nutritionHabits,
      fileUrls: fileUrls ?? this.fileUrls,
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        mainConcern,
        healthProfile,
        selfRatedHealth,
        lifestyleHabits,
        nutritionHabits,
        fileUrls,
        files,
        isLoading,
        errorMessage,
      ];
}

// Cubit untuk Precision Nutrition
class NutritionAssessmentCubit extends Cubit<NutritionAssessmentState> {
  final Dio _dio;

  NutritionAssessmentCubit(
    this._dio,
  ) : super(const NutritionAssessmentState());

  void setMainConcern(String concern) {
    emit(state.copyWith(mainConcern: concern));
  }

  void updateHealthProfile(HealthProfile profile) {
    emit(state.copyWith(healthProfile: profile));
  }

  void updateSelfRatedHealth(double rating) {
    emit(state.copyWith(selfRatedHealth: rating));
  }

  void updateLifestyleHabits(LifestyleHabits habits) {
    emit(state.copyWith(lifestyleHabits: habits));
  }

  void updateNutritionHabits(NutritionHabits habits) {
    emit(state.copyWith(nutritionHabits: habits));
  }

  void addFile(File file) {
    final newFiles = List<File>.from(state.files)..add(file);
    emit(state.copyWith(files: newFiles));
  }

  void removeFile(File file) {
    final newFiles = List<File>.from(state.files)..remove(file);
    emit(state.copyWith(files: newFiles));
  }

  void removeFileUrl(String url) {
    final newFileUrls = List<String>.from(state.fileUrls)..remove(url);
    emit(state.copyWith(fileUrls: newFileUrls));
  }

  Future<void> submitAssessment() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      List<MultipartFile> filesPayload = [];
      for (var file in state.files) {
        filesPayload.add(await MultipartFile.fromFile(
          file.path,
          filename: p.basename(file.path),
        ));
      }

      final payload = FormData.fromMap({
        'main_concern': state.mainConcern,
        'self_rated_health': state.selfRatedHealth,
        'age': state.healthProfile?.age,
        'gender': state.healthProfile?.gender,
        'known_condition': state.healthProfile?.knownCondition,
        'special_considerations[]':
            state.healthProfile?.specialConsiderations ?? [],
        'medication_history': state.healthProfile?.medicationHistory,
        'family_health_history': state.healthProfile?.familyHistory,
        'sleep_hours': state.lifestyleHabits?.sleepHours,
        'activity_level': state.lifestyleHabits?.activityLevel,
        'exercise_frequency': state.lifestyleHabits?.exerciseFrequency,
        'stress_level': state.lifestyleHabits?.stressLevel,
        'smoking_alcohol_habit': state.lifestyleHabits?.smokingAlcoholHabits,
        'meal_frequency': state.nutritionHabits?.mealFrequency,
        'food_sensitivities': state.nutritionHabits?.foodSensitivities,
        'favorite_foods': state.nutritionHabits?.favoriteFoods,
        'avoided_foods': state.nutritionHabits?.avoidedFoods,
        'water_intake': state.nutritionHabits?.waterIntake,
        'past_diet': state.nutritionHabits?.pastDiets,
        'medical_report_files[]': filesPayload
      });

      log('Payload of nutrtion assessment:\n ${payload.fields}',
          name: 'NutritionAssessmentCubit');
      Response response;
      final headers = Options(headers: {
        'Authorization': 'Bearer ${await Utils.getSpString(Const.TOKEN)}'
      });

      if (state.isSubmitted) {
        final url = '${Const.API_NUTRITION_ASSESSMENT}/${state.id}';
        log('Attempting to UPDATE (PUT) assessment id: ${state.id}\n at $url',
            name: 'NutritionAssessmentCubit');

        response = await _dio.put(
          url,
          data: payload,
          options: headers,
        );
      } else {
        log('Attempting to CREATE (POST) new assessment',
            name: 'NutritionAssessmentCubit');
        response = await _dio.post(
          Const.API_NUTRITION_ASSESSMENT,
          data: payload,
          options: headers,
        );
      }
      log('Status code: ${response.statusCode}',
          name: 'NutritionAssessmentCubit');
      log('Response:\n${response.data}', name: 'NutritionAssessmentCubit');

      emit(state.copyWith(isLoading: false));
    } catch (e, stackTrace) {
      log('Failed to submit nutrition assessment',
          error: e, stackTrace: stackTrace, name: 'NutritionAssessmentCubit');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit nutrition assessment',
      ));
    }
  }

  Future<bool> fetchAssessment() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await _dio.get(Const.API_NUTRITION_ASSESSMENT,
          options: Options(headers: {
            'Authorization': 'Bearer ${await Utils.getSpString(Const.TOKEN)}'
          }));
      log('Status code: ${response.statusCode}',
          name: 'NutritionAssessmentCubit');
      log('Response:\n${response.data}', name: 'NutritionAssessmentCubit');

      Map<String, dynamic> data = {};
      if (response.data is List) {
        if ((response.data as List).isEmpty) {
          emit(state.copyWith(isLoading: false)); // No data
          return false;
        }
        data = (response.data as List).first;
      } else if (response.data is Map<String, dynamic>) {
        data = response.data;
      }

      final newState = NutritionAssessmentState(
        id: data['id'],
        userId: data['user_id'],
        mainConcern: data['main_concern'],
        selfRatedHealth: (data['self_rated_health'] as num).toDouble(),
        fileUrls: List<String>.from(data['medical_report_files'] ?? []),
        healthProfile: HealthProfile(
          age: data['age'],
          gender: data['gender'],
          knownCondition: data['known_condition'],
          specialConsiderations:
              List<String>.from(data['special_considerations'] ?? []),
          medicationHistory: data['medication_history'],
          familyHistory: data['family_health_history'],
        ),
        lifestyleHabits: LifestyleHabits(
          sleepHours: (data['sleep_hours'] as num).toDouble(),
          activityLevel: data['activity_level'],
          exerciseFrequency: data['exercise_frequency'],
          stressLevel: data['stress_level'],
          smokingAlcoholHabits: data['smoking_alcohol_habit'],
        ),
        nutritionHabits: NutritionHabits(
          mealFrequency: data['meal_frequency'],
          foodSensitivities: data['food_sensitivities'],
          favoriteFoods: data['favorite_foods'],
          avoidedFoods: data['avoided_foods'],
          waterIntake: data['water_intake'],
          pastDiets: data['past_diet'],
        ),
      );

      emit(newState.copyWith(isLoading: false));
      return true;
    } catch (e, stackTrace) {
      log('Failed to fetch nutrition assessment',
          error: e, stackTrace: stackTrace, name: 'NutritionAssessmentCubit');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch nutrition assessment',
      ));
      return false;
    }
  }

  void resetState() {
    emit(const NutritionAssessmentState());
  }
}

// Model classes untuk data
class HealthProfile {
  final int age;
  final String gender;
  final String? knownCondition;
  final List<String> specialConsiderations;
  final String? medicationHistory;
  final String? familyHistory;

  HealthProfile({
    required this.age,
    required this.gender,
    this.knownCondition,
    this.specialConsiderations = const [],
    this.medicationHistory,
    this.familyHistory,
  });
}

class LifestyleHabits {
  final double sleepHours;
  final String activityLevel;
  final String exerciseFrequency;
  final String stressLevel;
  final String smokingAlcoholHabits;

  LifestyleHabits({
    required this.sleepHours,
    required this.activityLevel,
    required this.exerciseFrequency,
    required this.stressLevel,
    required this.smokingAlcoholHabits,
  });
}

class NutritionHabits {
  final String mealFrequency;
  final String foodSensitivities;
  final String favoriteFoods;
  final String avoidedFoods;
  final String waterIntake;
  final String pastDiets;

  NutritionHabits({
    required this.mealFrequency,
    required this.foodSensitivities,
    required this.favoriteFoods,
    required this.avoidedFoods,
    required this.waterIntake,
    required this.pastDiets,
  });
}
