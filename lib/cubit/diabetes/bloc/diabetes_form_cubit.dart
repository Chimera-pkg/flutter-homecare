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
      final bool hasBeenSubmitted = data['diabetes_type'] != null;

      DiabetesHistory loadedHistory = const DiabetesHistory();
      RiskFactors loadedRiskFactors = const RiskFactors();
      LifestyleSelfCare loadedLifestyleSelfCare = const LifestyleSelfCare();
      PhysicalSigns loadedPhysicalSigns = const PhysicalSigns();

      if (hasBeenSubmitted) {
        loadedHistory = DiabetesHistory(
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

        loadedRiskFactors = RiskFactors(
          hasHypertension: data['has_hypertension'] == 1,
          hasDyslipidemia: data['has_dyslipidemia'] == 1,
          hasCardiovascularDisease: data['has_cardiovascular_disease'] == 1,
          hasNeuropathy: data['has_neuropathy'] == 1,
          hasEyeDisease: data['has_eye_disease'] == 1,
          hasKidneyDisease: data['has_kidney_disease'] == 1,
          hasFamilyHistory: data['has_family_history'] == 1,
          smokingStatus: data['smoking_status'],
        );

        loadedLifestyleSelfCare = LifestyleSelfCare(
          recentHypoglycemia: data['recent_hypoglycemia'],
          physicalActivity: data['physical_activity'],
          dietQuality: data['diet_quality'],
        );

        loadedPhysicalSigns = PhysicalSigns(
          eyesLastExamDate: data['eyes_last_exam_date']?.toString(),
          eyesFindings: data['eyes_findings'],
          kidneysEgfr: data['kidneys_egfr'],
          kidneysUrineAcr: data['kidneys_urine_acr'],
          feetSkinStatus: data['feet_skin_status'],
          feetDeformityStatus: data['feet_deformity_status'],
        );
      }

      emit(state.copyWith(
        diabetesHistory: loadedHistory,
        riskFactors: loadedRiskFactors,
        lifestyleSelfCare: loadedLifestyleSelfCare,
        physicalSigns: loadedPhysicalSigns,
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
