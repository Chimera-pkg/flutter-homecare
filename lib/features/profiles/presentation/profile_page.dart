import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/features/profiles/presentation/pages/manage_provided_services_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/presentation/widgets/auth_guard_dialog.dart';
import 'package:m2health/core/presentation/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      return DateFormat('MMM dd, yyyy • HH:mm').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSpString(Const.ROLE),
      builder: (context, asyncSnapshot) {
        final String? role = asyncSnapshot.data;
        final bool isPatient = role == 'patient';
        final bool isAdmin = role == 'admin';

        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              isPatient ? 'My Health Profile' : 'My Profile',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUnauthenticated) {
                showAuthGuardDialog(context);
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              //  --- Patient Profile ---
              else if (state is PatientProfileLoaded) {
                final Profile profile = state.profile;
                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileHeader(
                          name: profile.name,
                          avatarUrl: profile.avatar,
                          lastUpdated: formatDateTime(profile.updatedAt),
                        ),
                        const SizedBox(height: 16),
                        if (isAdmin) ...[
                          const _AdminSection(),
                          const SizedBox(height: 16),
                        ],
                        if (isPatient) ...[
                          const _ProfileInformationSection(),
                          const SizedBox(height: 16),
                          const _HealthRecordsSection(),
                          const SizedBox(height: 16),
                          const _AppointmentSection(),
                          const SizedBox(height: 16),
                        ],
                        const _LogoutButton(),
                        const SizedBox(height: 80)
                      ],
                    ),
                  ),
                );
              }

              // --- Professional Profile ---
              else if (state is ProfessionalProfileLoaded) {
                final ProfessionalProfile profile = state.profile;
                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileHeader(
                          name: profile.name ?? 'N/A',
                          avatarUrl: profile.avatar,
                          lastUpdated: formatDateTime(profile.updatedAt),
                          isVerified: profile.isVerified,
                          verifiedAt: profile.verifiedAt,
                        ),
                        const SizedBox(height: 16),
                        _ProfessionalProfileSection(profile: profile),
                        const SizedBox(height: 16),
                        const _AppointmentSection(),
                        const SizedBox(height: 16),
                        const _LogoutButton(),
                        const SizedBox(height: 80)
                      ],
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No profile data found'));
              }
            },
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String lastUpdated;
  final bool? isVerified;
  final DateTime? verifiedAt;

  const _ProfileHeader({
    required this.name,
    this.avatarUrl,
    required this.lastUpdated,
    this.isVerified,
    this.verifiedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatarWidget(
          avatarUrl: avatarUrl,
          size: 100,
          borderRadius: 10,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // --- Verification Badge ---
              if (isVerified != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVerified!
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isVerified! ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVerified! ? Icons.verified : Icons.pending_outlined,
                        size: 14,
                        color: isVerified! ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isVerified! ? 'Verified' : 'Unverified',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isVerified! ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isVerified! && verifiedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Since: ${DateFormat('MMM dd, yyyy').format(verifiedAt!)}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
                const SizedBox(height: 8),
              ],
              // -------------------------------

              const Text(
                'Last updated:',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                lastUpdated,
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileInformationSection extends StatelessWidget {
  const _ProfileInformationSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            _ProfileListTile(
              title: 'Basic Information',
              svgAsset: 'assets/icons/lab_profile.svg',
              onTap: () {
                context.push(AppRoutes.profileBasicInfo);
              },
            ),
            _ProfileListTile(
              title: 'Medical History & Risk Factors',
              svgAsset: 'assets/icons/medical_report.svg',
              onTap: () {
                context.push(AppRoutes.profileMedicalHistory);
              },
            ),
            _ProfileListTile(
              title: 'Lifestyle & Selfcare',
              svgAsset: 'assets/icons/muscle.svg',
              onTap: () {
                context.push(AppRoutes.profileLifestyle);
              },
            ),
            _ProfileListTile(
              title: 'Physical Sign',
              svgAsset: 'assets/icons/physical_sign.svg',
              onTap: () {
                context.push(AppRoutes.profilePhysicalSigns);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthRecordsSection extends StatelessWidget {
  const _HealthRecordsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Records',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            _ProfileListTile(
              title: 'Medical Records',
              svgAsset: 'assets/icons/capsule_n_pill.svg',
              onTap: () {
                context.push(AppRoutes.medicalRecord);
              },
            ),
            _ProfileListTile(
              title: 'Pharmagenomics Profile',
              svgAsset: 'assets/icons/DNA.svg',
              onTap: () {
                context.push(AppRoutes.pharmagenomics);
              },
            ),
            _ProfileListTile(
              title: 'Wellness Genomics Profile',
              svgAsset: 'assets/icons/DNA.svg',
              onTap: () {
                context.push(AppRoutes.wellnessGenomics);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentSection extends StatelessWidget {
  const _AppointmentSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading:
                  const Icon(Icons.calendar_today, color: Color(0xFF35C5CF)),
              title: const Text('All My Appointments'),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.go(AppRoutes.appointment);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfessionalProfileSection extends StatelessWidget {
  final ProfessionalProfile profile;
  const _ProfessionalProfileSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Panel',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading: const Icon(
                Icons.assignment_ind,
                color: Color(0xFF35C5CF),
              ),
              title: const Text('Edit Professional Profile'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                context.push(AppRoutes.editProfessionalProfile, extra: profile);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.list_alt,
                color: Color(0xFF35C5CF),
              ),
              title: const Text('My Services'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () async {
                final role = await Utils.getSpString(Const.ROLE);
                if (role == null) return;

                await GoRouter.of(context).pushNamed(
                  AppRoutes.editProfessionalServices,
                  extra: ManageServicesArgs(
                    role: role,
                    isHomeScreeningAuthorized:
                        profile.isHomeScreeningAuthorized ?? false,
                    currentServices: profile.providedServices,
                  ),
                );

                context.read<ProfileCubit>().loadProfile();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_month,
                color: Color(0xFF35C5CF),
              ),
              title: const Text('My Schedule'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                context.push(AppRoutes.workingSchedule);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSection extends StatelessWidget {
  const _AdminSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Panel',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF35C5CF)),
              title: const Text('Manage Services'),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                GoRouter.of(context).push(AppRoutes.manageServices);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.health_and_safety, color: Color(0xFF35C5CF)),
              title: const Text('Manage Health Screening'),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(AppRoutes.manageHealthScreening);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.verified_user, color: Color(0xFF35C5CF)),
              title: const Text('Verify Professionals'),
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.push(AppRoutes.adminProfessionals);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () async {
          await Utils.clearSp();
          if (context.mounted) {
            context.read<AuthCubit>().loggedOut();
          }
        },
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final String title;
  final String svgAsset;
  final VoidCallback onTap;

  const _ProfileListTile({
    required this.title,
    required this.svgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 28,
        width: 24,
        child: SvgPicture.asset(
          svgAsset,
          height: 28,
          colorFilter: const ColorFilter.mode(Const.aqua, BlendMode.srcIn),
        ),
      ),
      title: Text(title),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
