import 'package:equatable/equatable.dart';


class DiabetesFormState extends Equatable {
  final DiabetesHistory diabetesHistory;
  final RiskFactors riskFactors;
  final LifestyleSelfCare lifestyleSelfCare;
  final PhysicalSigns physicalSigns;
  final bool isLoading;
  final String? errorMessage;
  final bool isSubmitted; 

  const DiabetesFormState({
    this.diabetesHistory = const DiabetesHistory(),
    this.riskFactors = const RiskFactors(),
    this.lifestyleSelfCare = const LifestyleSelfCare(),
    this.physicalSigns = const PhysicalSigns(),
    this.isLoading = false,
    this.errorMessage,
    this.isSubmitted = false,
  });

  DiabetesFormState copyWith({
    DiabetesHistory? diabetesHistory,
    RiskFactors? riskFactors,
    LifestyleSelfCare? lifestyleSelfCare,
    PhysicalSigns? physicalSigns,
    bool? isLoading,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return DiabetesFormState(
      diabetesHistory: diabetesHistory ?? this.diabetesHistory,
      riskFactors: riskFactors ?? this.riskFactors,
      lifestyleSelfCare: lifestyleSelfCare ?? this.lifestyleSelfCare,
      physicalSigns: physicalSigns ?? this.physicalSigns,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        diabetesHistory,
        riskFactors,
        lifestyleSelfCare,
        physicalSigns,
        isLoading,
        errorMessage,
        isSubmitted,
      ];
}

class DiabetesHistory extends Equatable {
  final String? diabetesType;
  final int? yearOfDiagnosis;
  final double? lastHbA1c;
  final bool hasTreatmentDiet;
  final bool hasTreatmentOral; // for checkbox
  final String? oralMedication;
  final bool hasTreatmentInsulin; // for checkbox
  final String? insulinTypeDose;

  const DiabetesHistory({
    this.diabetesType,
    this.yearOfDiagnosis,
    this.lastHbA1c,
    this.hasTreatmentDiet = false,
    this.hasTreatmentOral = false,
    this.oralMedication,
    this.hasTreatmentInsulin = false,
    this.insulinTypeDose,
  });

  @override
  List<Object?> get props => [
        diabetesType,
        yearOfDiagnosis,
        lastHbA1c,
        hasTreatmentDiet,
        hasTreatmentOral,
        oralMedication,
        hasTreatmentInsulin,
        insulinTypeDose,
      ];

  DiabetesHistory copyWith({
    String? diabetesType,
    int? yearOfDiagnosis,
    double? lastHbA1c,
    bool? hasTreatmentDiet,
    bool? hasTreatmentOral,
    String? oralMedication,
    bool? hasTreatmentInsulin,
    String? insulinTypeDose,
  }) {
    return DiabetesHistory(
      diabetesType: diabetesType ?? this.diabetesType,
      yearOfDiagnosis: yearOfDiagnosis ?? this.yearOfDiagnosis,
      lastHbA1c: lastHbA1c ?? this.lastHbA1c,
      hasTreatmentDiet: hasTreatmentDiet ?? this.hasTreatmentDiet,
      hasTreatmentOral: hasTreatmentOral ?? this.hasTreatmentOral,
      oralMedication: oralMedication ?? this.oralMedication,
      hasTreatmentInsulin: hasTreatmentInsulin ?? this.hasTreatmentInsulin,
      insulinTypeDose: insulinTypeDose ?? this.insulinTypeDose,
    );
  }
}

class RiskFactors extends Equatable {
  final bool? hasHypertension;
  final bool? hasDyslipidemia;
  final bool? hasCardiovascularDisease;
  final bool? hasNeuropathy;
  final bool? hasEyeDisease;
  final bool? hasKidneyDisease;
  final bool? hasFamilyHistory;
  final String? smokingStatus;

  const RiskFactors({
    this.hasHypertension,
    this.hasDyslipidemia,
    this.hasCardiovascularDisease,
    this.hasNeuropathy,
    this.hasEyeDisease,
    this.hasKidneyDisease,
    this.hasFamilyHistory,
    this.smokingStatus,
  });

  @override
  List<Object?> get props => [
        hasHypertension,
        hasDyslipidemia,
        hasCardiovascularDisease,
        hasNeuropathy,
        hasEyeDisease,
        hasKidneyDisease,
        hasFamilyHistory,
        smokingStatus,
      ];

  RiskFactors copyWith({
    bool? hasHypertension,
    bool? hasDyslipidemia,
    bool? hasCardiovascularDisease,
    bool? hasNeuropathy,
    bool? hasEyeDisease,
    bool? hasKidneyDisease,
    bool? hasFamilyHistory,
    String? smokingStatus,
  }) {
    return RiskFactors(
      hasHypertension: hasHypertension ?? this.hasHypertension,
      hasDyslipidemia: hasDyslipidemia ?? this.hasDyslipidemia,
      hasCardiovascularDisease:
          hasCardiovascularDisease ?? this.hasCardiovascularDisease,
      hasNeuropathy: hasNeuropathy ?? this.hasNeuropathy,
      hasEyeDisease: hasEyeDisease ?? this.hasEyeDisease,
      hasKidneyDisease: hasKidneyDisease ?? this.hasKidneyDisease,
      hasFamilyHistory: hasFamilyHistory ?? this.hasFamilyHistory,
      smokingStatus: smokingStatus ?? this.smokingStatus,
    );
  }
}

class LifestyleSelfCare extends Equatable {
  final String? recentHypoglycemia;
  final String? physicalActivity;
  final String? dietQuality;

  const LifestyleSelfCare({
    this.recentHypoglycemia,
    this.physicalActivity,
    this.dietQuality,
  });

  @override
  List<Object?> get props => [
        recentHypoglycemia,
        physicalActivity,
        dietQuality,
      ];

  LifestyleSelfCare copyWith({
    String? recentHypoglycemia,
    String? physicalActivity,
    String? dietQuality,
  }) {
    return LifestyleSelfCare(
      recentHypoglycemia: recentHypoglycemia ?? this.recentHypoglycemia,
      physicalActivity: physicalActivity ?? this.physicalActivity,
      dietQuality: dietQuality ?? this.dietQuality,
    );
  }
}

class PhysicalSigns extends Equatable {
  final String? eyesLastExamDate;
  final String? eyesFindings;
  final String? kidneysEgfr;
  final String? kidneysUrineAcr;
  final String? feetSkinStatus;
  final String? feetDeformityStatus;

  const PhysicalSigns({
    this.eyesLastExamDate,
    this.eyesFindings,
    this.kidneysEgfr,
    this.kidneysUrineAcr,
    this.feetSkinStatus,
    this.feetDeformityStatus,
  });

  @override
  List<Object?> get props => [
        eyesLastExamDate,
        eyesFindings,
        kidneysEgfr,
        kidneysUrineAcr,
        feetSkinStatus,
        feetDeformityStatus,
      ];

  PhysicalSigns copyWith({
    String? eyesLastExamDate,
    String? eyesFindings,
    String? kidneysEgfr,
    String? kidneysUrineAcr,
    String? feetSkinStatus,
    String? feetDeformityStatus,
  }) {
    return PhysicalSigns(
      eyesLastExamDate: eyesLastExamDate ?? this.eyesLastExamDate,
      eyesFindings: eyesFindings ?? this.eyesFindings,
      kidneysEgfr: kidneysEgfr ?? this.kidneysEgfr,
      kidneysUrineAcr: kidneysUrineAcr ?? this.kidneysUrineAcr,
      feetSkinStatus: feetSkinStatus ?? this.feetSkinStatus,
      feetDeformityStatus: feetDeformityStatus ?? this.feetDeformityStatus,
    );
  }
}
