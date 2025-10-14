import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/utils.dart';

class DiabetesFormCubit extends Cubit<DiabetesFormState> {
  final Dio _dio;

  DiabetesFormCubit(this._dio) : super(const DiabetesFormState());

  Future<bool> loadForm() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      const url = Const.API_DIABETES_PROFILE;
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['data'];
      final loadedHistory = DiabetesHistory(
        diabetesType: data['diabetes_type'],
        yearOfDiagnosis: data['year_of_diagnosis'],
        lastHbA1c: data['last_hba1c'] != null
            ? double.tryParse(data['last_hba1c'].toString())
            : null,
        hasTreatmentDiet: data['treatment_diet_exercise'] != null,
        hasTreatmentOral: data['treatment_oral_meds'] != null,
        oralMedication: data['treatment_oral_meds'],
        hasTreatmentInsulin: data['treatment_insulin'] != null,
        insulinTypeDose: data['treatment_insulin'],
      );

      final loadedRiskFactors = RiskFactors(
        hasHypertension: data['has_hypertension'] == 1,
        hasDyslipidemia: data['has_dyslipidemia'] == 1,
        hasCardiovascularDisease: data['has_cardiovascular_disease'] == 1,
        hasNeuropathy: data['has_neuropathy'] == 1,
        hasEyeDisease: data['has_eye_disease'] == 1,
        hasKidneyDisease: data['has_kidney_disease'] == 1,
        hasFamilyHistory: data['has_family_history'] == 1,
        smokingStatus: data['smoking_status'],
      );

      final loadedLifestyleSelfCare = LifestyleSelfCare(
        recentHypoglycemia: data['recent_hypoglycemia'],
        physicalActivity: data['physical_activity'],
        dietQuality: data['diet_quality'],
      );

      final loadedPhysicalSigns = PhysicalSigns(
        eyesLastExamDate: data['eyes_last_exam_date']?.toString(),
        eyesFindings: data['eyes_findings'],
        kidneysEgfr: data['kidneys_egfr'],
        kidneysUrineAcr: data['kidneys_urine_acr'],
        feetSkinStatus: data['feet_skin_status'],
        feetDeformityStatus: data['feet_deformity_status'],
      );

      emit(state.copyWith(
        diabetesHistory: loadedHistory,
        riskFactors: loadedRiskFactors,
        lifestyleSelfCare: loadedLifestyleSelfCare,
        physicalSigns: loadedPhysicalSigns,
        isSubmitted: true,
        isLoading: false,
      ));
      return true;
    } catch (e, s) {
      log('Error checking form status: $e',
          name: 'DiabetesFormCubit', stackTrace: s);

      emit(state.copyWith(
        isSubmitted: false,
        errorMessage: 'Failed to check your profile. Please try again.',
        isLoading: false,
      ));

      return false;
    }
  }

  void updateDiabetesHistory(DiabetesHistory history) {
    emit(state.copyWith(diabetesHistory: history));
  }

  void updateMedicalHistoryRiskFactors(RiskFactors factors) {
    emit(state.copyWith(riskFactors: factors));
  }

  void updateLifestyleSelfCare(LifestyleSelfCare lifestyle) {
    emit(state.copyWith(lifestyleSelfCare: lifestyle));
  }

  void updatePhysicalSigns(PhysicalSigns signs) {
    emit(state.copyWith(physicalSigns: signs));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final diabetesHistory = state.diabetesHistory;
    final medicalHistory = state.riskFactors;
    final lifestyle = state.lifestyleSelfCare;
    final physicalSigns = state.physicalSigns;
    try {
      final formData = {
        'diabetes_type': diabetesHistory.diabetesType,
        'year_of_diagnosis': diabetesHistory.yearOfDiagnosis,
        'last_hba1c': diabetesHistory.lastHbA1c,
        'treatment_diet_exercise': diabetesHistory.hasTreatmentDiet,
        'treatment_oral_meds': diabetesHistory.hasTreatmentOral
            ? diabetesHistory.oralMedication
            : null,
        'treatment_insulin': diabetesHistory.hasTreatmentInsulin
            ? diabetesHistory.insulinTypeDose
            : null,
        'has_hypertension': medicalHistory.hasHypertension,
        'has_dyslipidemia': medicalHistory.hasDyslipidemia,
        'has_cardiovascular_disease': medicalHistory.hasCardiovascularDisease,
        'has_neuropathy': medicalHistory.hasNeuropathy,
        'has_eye_disease': medicalHistory.hasEyeDisease,
        'has_kidney_disease': medicalHistory.hasKidneyDisease,
        'has_family_history': medicalHistory.hasFamilyHistory,
        'smoking_status': medicalHistory.smokingStatus,
        'recent_hypoglycemia': lifestyle.recentHypoglycemia,
        'physical_activity': lifestyle.physicalActivity,
        'diet_quality': lifestyle.dietQuality,
        'eyes_last_exam_date': physicalSigns.eyesLastExamDate,
        'eyes_findings': physicalSigns.eyesFindings,
        'kidneys_egfr': physicalSigns.kidneysEgfr,
        'kidneys_urine_acr': physicalSigns.kidneysUrineAcr,
        'feet_skin_status': physicalSigns.feetSkinStatus,
        'feet_deformity_status': physicalSigns.feetDeformityStatus,
      };

      const url = Const.API_DIABETES_PROFILE;
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Error: ${response.data['message']}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred: $e',
      ));
    }
  }
}
