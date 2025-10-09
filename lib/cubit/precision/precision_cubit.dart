import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// State untuk Precision Nutrition Assessment
class PrecisionState extends Equatable {
  final String? mainConcern;
  final HealthProfile? healthProfile;
  final double selfRatedHealth;
  final LifestyleHabits? lifestyleHabits;
  final NutritionHabits? nutritionHabits;
  final List<String> uploadedFiles;
  final bool isLoading;
  final String? errorMessage;
  final bool isSubmitted;

  const PrecisionState({
    this.mainConcern,
    this.healthProfile,
    this.selfRatedHealth = 1.0,
    this.lifestyleHabits,
    this.nutritionHabits,
    this.uploadedFiles = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSubmitted = false,
  });

  PrecisionState copyWith({
    String? mainConcern,
    HealthProfile? healthProfile,
    double? selfRatedHealth,
    LifestyleHabits? lifestyleHabits,
    NutritionHabits? nutritionHabits,
    List<String>? uploadedFiles,
    bool? isLoading,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return PrecisionState(
      mainConcern: mainConcern ?? this.mainConcern,
      healthProfile: healthProfile ?? this.healthProfile,
      selfRatedHealth: selfRatedHealth ?? this.selfRatedHealth,
      lifestyleHabits: lifestyleHabits ?? this.lifestyleHabits,
      nutritionHabits: nutritionHabits ?? this.nutritionHabits,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        mainConcern,
        healthProfile,
        selfRatedHealth,
        lifestyleHabits,
        nutritionHabits,
        uploadedFiles,
        isLoading,
        errorMessage,
        isSubmitted,
      ];
}

// Cubit untuk Precision Nutrition
class PrecisionCubit extends Cubit<PrecisionState> {
  PrecisionCubit() : super(const PrecisionState());

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

  void addUploadedFile(String fileName) {
    final newFiles = List<String>.from(state.uploadedFiles)..add(fileName);
    emit(state.copyWith(uploadedFiles: newFiles));
  }

  void removeUploadedFile(String fileName) {
    final newFiles = List<String>.from(state.uploadedFiles)..remove(fileName);
    emit(state.copyWith(uploadedFiles: newFiles));
  }

  Future<void> submitAssessment() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      // Simulate API call with dummy data
      await Future.delayed(const Duration(seconds: 2));
      
      // Success - no error
      emit(state.copyWith(isLoading: false, isSubmitted: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit assessment: ${e.toString()}',
        isSubmitted: false,
      ));
    }
  }

  void resetState() {
    emit(const PrecisionState());
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
