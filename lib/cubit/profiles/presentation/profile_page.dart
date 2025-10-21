import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/widgets/auth_guard_dialog.dart';

class ProfilePage extends StatefulWidget {
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
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSpString(Const.ROLE),
      builder: (context, asyncSnapshot) {
        final String? role = asyncSnapshot.data;
        final bool isPatient = role == 'patient';
        final bool isProfessional =
            ['nurse', 'pharmacist', 'radiologist'].contains(role);
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
              } else if (state is ProfileLoaded) {
                final Profile profile = state.profile;
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileCubit>().loadProfile();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // --- Header Section ---
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await context.push(
                                  AppRoutes.editProfile,
                                  extra: state.profile,
                                );
                                if (context.mounted) {
                                  context.read<ProfileCubit>().loadProfile();
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  state.profile.avatar ?? '',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.profile.username,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Last updated:',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    formatDateTime(state.profile.updatedAt),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (isPatient)
                          _buildHealthRecordsSection(context)
                        else if (isProfessional)
                          _buildProfessionalProfileSection(
                            context,
                            profile: profile,
                          )
                        else if (isAdmin)
                          _buildAdminSection(context),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          shadowColor: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Appointment',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.calendar_today,
                                      color: Color(0xFF35C5CF)),
                                  title: const Text('All My Appointments'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    context.go(AppRoutes.appointment);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile Information',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await context.push(
                                  AppRoutes.editProfile,
                                  extra: state.profile,
                                );
                                if (context.mounted) {
                                  context.read<ProfileCubit>().loadProfile();
                                }
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                  'Age: ${state.profile.age} | Weight: ${state.profile.weight} KG | Height: ${state.profile.height} cm'),
                              const SizedBox(height: 8),
                              Text(
                                  'Phone Number: ${state.profile.phoneNumber}'),
                              const SizedBox(height: 8),
                              Text(
                                  'Home Address (Primary): ${state.profile.homeAddress}'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await Utils.clearSp();
                              debugPrint('Data telah dibersihkan');
                              GoRouter.of(context).go(AppRoutes.signIn);
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text('Logout',
                                style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildProfessionalProfileSection(BuildContext context,
      {required Profile profile}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(
                Icons.assignment_ind,
                color: Color(0xFF35C5CF),
              ),
              title: const Text('Edit Professional Profile'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                context.push(AppRoutes.editProfessionalProfile, extra: profile);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRecordsSection(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Records',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(
                Icons.medical_services,
                color: Color(0xFF35C5CF),
              ),
              title: const Text('Medical Records'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                context.push(AppRoutes.medicalRecord);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.local_pharmacy, color: Color(0xFF35C5CF)),
              title: const Text('Pharmagenomics Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push(AppRoutes.pharmagenomics);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.local_pharmacy, color: Color(0xFF35C5CF)),
              title: const Text('Wellness Genomics Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Coming Soon'),
                    content: const Text('This feature is under development.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSection(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Panel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF35C5CF)),
              title: const Text('Manage Services'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                GoRouter.of(context).push(AppRoutes.manageServices);
              },
            ),
          ],
        ),
      ),
    );
  }
}
