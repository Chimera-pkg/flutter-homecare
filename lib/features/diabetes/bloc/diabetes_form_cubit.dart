import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
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
      log('Loaded diabetes profile data: $data', name: 'DiabetesFormCubit');
      final bool hasBeenSubmitted = data['diabetes_type'] != null;

      final diabetesHistory = DiabetesHistory(
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

      // Helper to convert integer to nullable bool
      bool? toNullableBool(dynamic value) {
        return value == null ? null : value == 1;
      }

      final riskFactors = RiskFactors(
        hasHypertension: toNullableBool(data['has_hypertension']),
        hasDyslipidemia: toNullableBool(data['has_dyslipidemia']),
        hasCardiovascularDisease:
            toNullableBool(data['has_cardiovascular_disease']),
        hasNeuropathy: toNullableBool(data['has_neuropathy']),
        hasEyeDisease: toNullableBool(data['has_eye_disease']),
        hasKidneyDisease: toNullableBool(data['has_kidney_disease']),
        hasFamilyHistory: toNullableBool(data['has_family_history']),
        smokingStatus: data['smoking_status'],
      );

      final lifestyleSelfCare = LifestyleSelfCare(
        recentHypoglycemia: data['recent_hypoglycemia'],
        physicalActivity: data['physical_activity'],
        dietQuality: data['diet_quality'],
      );

      final physicalSigns = PhysicalSigns(
        eyesLastExamDate: data['eyes_last_exam_date']?.toString(),
        eyesFindings: data['eyes_findings'],
        kidneysEgfr: data['kidneys_egfr'],
        kidneysUrineAcr: data['kidneys_urine_acr'],
        feetSkinStatus: data['feet_skin_status'],
        feetDeformityStatus: data['feet_deformity_status'],
      );

      emit(state.copyWith(
        diabetesHistory: diabetesHistory,
        riskFactors: riskFactors,
        lifestyleSelfCare: lifestyleSelfCare,
        physicalSigns: physicalSigns,
        isSubmitted: hasBeenSubmitted,
        isLoading: false,
      ));
      return hasBeenSubmitted;
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

  Future<bool> submitForm() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final diabetesHistory = state.diabetesHistory;
    final medicalHistory = state.riskFactors;
    final lifestyle = state.lifestyleSelfCare;
    final physicalSigns = state.physicalSigns;
    try {
      final formData = FormData.fromMap({
        'diabetesType': diabetesHistory.diabetesType,
        'yearOfDiagnosis': diabetesHistory.yearOfDiagnosis,
        'lastHba1c': diabetesHistory.lastHbA1c,
        'treatmentDietExercise': diabetesHistory.hasTreatmentDiet,
        'treatmentOralMeds': diabetesHistory.hasTreatmentOral
            ? diabetesHistory.oralMedication
            : null,
        'treatmentInsulin': diabetesHistory.hasTreatmentInsulin
            ? diabetesHistory.insulinTypeDose
            : null,
        'hasHypertension': medicalHistory.hasHypertension,
        'hasDyslipidemia': medicalHistory.hasDyslipidemia,
        'hasCardiovascularDisease': medicalHistory.hasCardiovascularDisease,
        'hasNeuropathy': medicalHistory.hasNeuropathy,
        'hasEyeDisease': medicalHistory.hasEyeDisease,
        'hasKidneyDisease': medicalHistory.hasKidneyDisease,
        'hasFamilyHistory': medicalHistory.hasFamilyHistory,
        'smokingStatus': medicalHistory.smokingStatus,
        'recentHypoglycemia': lifestyle.recentHypoglycemia,
        'physicalActivity': lifestyle.physicalActivity,
        'dietQuality': lifestyle.dietQuality,
        'eyesLastExamDate': physicalSigns.eyesLastExamDate,
        'eyesFindings': physicalSigns.eyesFindings,
        'kidneysEgfr': physicalSigns.kidneysEgfr,
        'kidneysUrineAcr': physicalSigns.kidneysUrineAcr,
        'feetSkinStatus': physicalSigns.feetSkinStatus,
        'feetDeformityStatus': physicalSigns.feetDeformityStatus,
      });

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

      emit(state.copyWith(
        isLoading: false,
        isSubmitted: true,
      ));
      return true;
    } on DioException catch (dioError, s) {
      final errorMessage =
          dioError.response?.data['message'] ?? 'An error occurred';
      log(
        'Dio error submitting form: $errorMessage',
        name: 'DiabetesFormCubit',
        error: dioError,
        stackTrace: s,
      );
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occured.',
      ));
      return false;
    } catch (e, s) {
      log(
        'Error submitting form: $e',
        name: 'DiabetesFormCubit',
        error: e,
        stackTrace: s,
      );
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred.',
      ));
      return false;
    }
  }
}
