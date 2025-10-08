import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/presentation/edit_professional_profile.dart';
import 'package:m2health/cubit/profiles/presentation/edit_profile.dart';
import 'package:m2health/cubit/profiles/profile_details/medical_record/medical_record.dart';
import 'package:m2health/route/app_routes.dart';

class ProfileDetailRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.medicalRecord,
      builder: (context, state) {
        return MedicalRecordsPage();
      },
    ),
    GoRoute(
      path: AppRoutes.pharmagenomics,
      builder: (context, state) {
        return PharmagenomicsProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) {
        Profile profile = state.extra as Profile;
        return EditProfilePage(profile: profile);
      },
    ),
    GoRoute(
      path: AppRoutes.editProfessionalProfile,
      builder: (context, state) {
        Profile profile = state.extra as Profile;
        return EditProfessionalProfilePage(profile: profile);
      },
    ),
  ];
}
