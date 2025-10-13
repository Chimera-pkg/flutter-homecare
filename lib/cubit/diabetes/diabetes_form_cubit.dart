import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/diabetes/diabetes_form_state.dart';
import 'package:m2health/utils.dart';

class DiabetesFormCubit extends Cubit<DiabetesFormState> {
  final _dio = Dio();

  DiabetesFormCubit() : super(const DiabetesFormState());

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

      const url = '${Const.BASE_URL}/diabetes-profiles';
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
