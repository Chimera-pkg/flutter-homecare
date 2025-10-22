class AppRoutes {
  // Core
  static const String home = '/';
  static const String dashboard = home;
  static const String appointment = '/appointment';
  static const String medicalStore = '/medical-store';
  static const String favourite = '/favourite';
  static const String profile = '/profile';

  // Auth
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';

  // Dasboard Services
  static const String pharmaServices = '/pharma-services';
  static const String nursingServices = '/nursing-services';
  static const String diabeticCare = '/diabetic-care';
  static const String homeHealthScreening = '/home-health-screening';
  static const String remotePatientMonitoring = '/remote-patient-monitoring';
  static const String secondOpinionMedical = '/second-opinion-medical';
  static const String precisionNutrition = '/precision-nutrition';

  // Appointment
  static const String appointmentDetail = '/appointment/detail';
  static const String bookAppointment = '/appointment/book';
  static const String providerAppointment = '/provider-appointment';

  // Profile Detail
  static const String medicalRecord = '/medical-record';
  static const String pharmagenomics = '/pharmagenomics';
  static const String wellnessGenomics = '/wellness-genomics';
  static const String editProfile = '/edit-profile';
  static const String editProfessionalProfile = '/edit-professional-profile';
  static const String manageServices = '/manage-services';

  static const String partnership = '/request-partnership';
  static const String partnership_list = '/partnership-list';
  static const String service_request = '/service-request';
  static const String chat = '/chat';
  static const String pharma_profile = '/pharma-profile';
  static const String personal = '/personal';
  static const String nursing = '/nursing';
  static const String submenu = '/submenu';

  // Precision Nutrition Module
  static const String precisionNutritionAssessmentForm =
      '$precisionNutrition/assessment/form';
  static const String precisionNutritionAssessmentDetail =
      '$precisionNutrition/assessment/detail';
  static const String precisionNutritionPlan = '$precisionNutrition/plan';
  static const String weeklyMealPlan = '$precisionNutrition/plan/meal';
  static const String weeklyMealPlanDetail =
      '$precisionNutrition/plan/meal/detail';
  static const String implementationJourney =
      '$precisionNutrition/implementation-journey';

  // Diabetic Care Module
  static const String diabeticProfileForm = '$diabeticCare/profile/form';
  static const String diabeticProfileSummary = '$diabeticCare/profile/summary';

  // static const String home = '/';
  // static const String submenu = 'submenu';
  // static const String dashboard= 'dashboard';
  // static const String signIn = 'sign-in';
  // static const String signUp = 'sign-up';
  // static const String signIn = '/sign-in';
}
