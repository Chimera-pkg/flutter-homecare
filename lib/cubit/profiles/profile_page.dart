import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/pharmagenomical_pages.dart';
import 'package:m2health/cubit/profiles/ServicesEdit_admin.dart';
import 'package:m2health/cubit/profiles/profile_cubit.dart';
import 'package:m2health/cubit/profiles/profile_details/edit_profile.dart';
import 'package:m2health/cubit/profiles/profile_state.dart';
import 'package:m2health/cubit/profiles/profile_details/medical_record/medical_record.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/appointment/appointment_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
// Add this helper method to format the date
  String formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy • HH:mm').format(dateTime);
    } catch (e) {
      // If parsing fails, return the original string
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(Dio())..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'My Health Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUnauthenticated) {
              // Show dialog to inform user they need to login
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Authentication Required'),
                    content: const Text(
                      'Your session has expired or you are not logged in. Please sign in to continue.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Sign In'),
                        onPressed: () {
                          // Close dialog and navigate to sign-in page
                          Navigator.of(dialogContext).pop();
                          GoRouter.of(context).go(AppRoutes.signIn);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileUnauthenticated) {
                // Already handled in listener, show a message while redirecting
                return const Center(
                  child: Text(
                    'Authentication required. Redirecting to sign-in...',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is ProfileLoaded) {
                final isAdmin = Utils.getSpString(Const.ROLE) == 'admin';
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileCubit>().fetchProfile();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await context.push(
                                  AppRoutes.editProfile,
                                  extra: EditProfilePageArgs(
                                    profileCubit: context.read<ProfileCubit>(),
                                    profile: state.profile,
                                  ),
                                );
                                if (context.mounted) {
                                  context.read<ProfileCubit>().fetchProfile();
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  state.profile.avatar,
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
                            Column(
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
                          ],
                        ),
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
                                // ListTile(
                                //   leading: const Icon(Icons.upload_file_outlined,
                                //       color: Color(0xFF35C5CF)),
                                //   title: const Text('Upload Report'),
                                //   trailing: const Icon(Icons.arrow_forward_ios),
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => UploadPDFPage()),
                                //     );
                                //   },
                                // ),
                                ListTile(
                                  leading: const Icon(Icons.local_pharmacy,
                                      color: Color(0xFF35C5CF)),
                                  title: const Text('Pharmagenomics Profile'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    context.push(AppRoutes.pharmagenomics);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.local_pharmacy,
                                      color: Color(0xFF35C5CF)),
                                  title:
                                      const Text('Wellness Genomics Profile'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Coming Soon'),
                                        content: const Text(
                                            'This feature is under development.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                if (isAdmin)
                                  ListTile(
                                    leading: const Icon(Icons.edit_note,
                                        color: Color(0xFF35C5CF)),
                                    title: const Text(
                                        'Edit Service Titles (admin)'),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceTitlesEditPage(),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
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
                                  extra: EditProfilePageArgs(
                                    profileCubit: context.read<ProfileCubit>(),
                                    profile: state.profile,
                                  ),
                                );
                                if (context.mounted) {
                                  context.read<ProfileCubit>().fetchProfile();
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
        ),
      ),
    );
  }
}
