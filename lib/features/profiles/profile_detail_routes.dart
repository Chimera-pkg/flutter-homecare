import 'package:go_router/go_router.dart';
import 'package:m2health/features/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/manage_services_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_lifestyle_n_selfcare_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_medical_history_n_risk_factor_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_physical_sign_page.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_professional_profile.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_basic_info_page.dart';
import 'package:m2health/features/medical_record/presentation/pages/medical_records_page.dart';
import 'package:m2health/features/schedule/presentation/pages/working_schedule_page.dart';
import 'package:m2health/features/wellness_genomics/presentation/pages/wellness_genomics_page.dart';
import 'package:m2health/route/app_routes.dart';

class ProfileDetailRoutes {
  static List<GoRoute> routes = [
    // Profile Information
    GoRoute(
      path: AppRoutes.profileBasicInfo,
      name: AppRoutes.profileBasicInfo,
      builder: (context, state) {
        return const EditBasicInfoPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profileMedicalHistory,
      name: AppRoutes.profileMedicalHistory,
      builder: (context, state) {
        return const EditMedicalHistoryNRiskFactorPage();
      },
    ),
    GoRoute(
      path: AppRoutes.profileLifestyle,
      name: AppRoutes.profileLifestyle,
      builder: (context, state) {
        return const EditLifestyleNSelfcarePage();
      },
    ),
    GoRoute(
      path: AppRoutes.profilePhysicalSigns,
      name: AppRoutes.profilePhysicalSigns,
      builder: (context, state) {
        return const EditPhysicalSignPage();
      },
    ),

    // Health Records
    GoRoute(
      path: AppRoutes.medicalRecord,
      builder: (context, state) {
        return const MedicalRecordsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.pharmagenomics,
      builder: (context, state) {
        return const PharmagenomicsProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.wellnessGenomics,
      builder: (context, state) {
        return const WellnessGenomicsProfilePage();
      },
    ),

    // Professional Profile
    GoRoute(
      path: AppRoutes.editProfessionalProfile,
      builder: (context, state) {
        ProfessionalProfile profile = state.extra as ProfessionalProfile;
        return EditProfessionalProfilePage(profile: profile);
      },
    ),
    GoRoute(
      path: AppRoutes.workingSchedule,
      name: AppRoutes.workingSchedule,
      builder: (context, state) {
        // Pass the provider ID and Type from the profile state
        // This assumes you have access to the ProfileCubit here or pass it as an extra
        return const WorkingSchedulePage();
      },
    ),

    // Admin Panel
    GoRoute(
      path: AppRoutes.manageServices,
      builder: (context, state) {
        return const ManageServicesPage();
      },
    ),
  ];
}
