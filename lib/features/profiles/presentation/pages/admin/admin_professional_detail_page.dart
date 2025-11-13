import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/presentation/bloc/admin_professional_detail_cubit.dart';
import 'package:m2health/features/profiles/presentation/pages/edit_professional_profile.dart';

class AdminProfessionalDetailPage extends StatelessWidget {
  final int professionalId;
  final String role;

  const AdminProfessionalDetailPage({
    super.key,
    required this.professionalId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminProfessionalDetailCubit(GetIt.I<ProfileRemoteDatasource>())
            ..loadDetail(professionalId, role),
      child: const _AdminProfessionalDetailView(),
    );
  }
}

class _AdminProfessionalDetailView extends StatefulWidget {
  const _AdminProfessionalDetailView();

  @override
  State<_AdminProfessionalDetailView> createState() =>
      _AdminProfessionalDetailViewState();
}

class _AdminProfessionalDetailViewState
    extends State<_AdminProfessionalDetailView> {
  bool _isLoadingAction = false;

  @override
  Widget build(BuildContext context) {
    final parent =
        context.findAncestorWidgetOfExactType<AdminProfessionalDetailPage>();
    final String role = parent?.role ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Professional Detail",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<AdminProfessionalDetailCubit,
          AdminProfessionalDetailState>(
        listener: (context, state) {
          if (state is AdminProDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
            setState(() => _isLoadingAction = false);
          } else if (state is AdminProDetailVerified) {
            final isNowVerified = state.profile.isVerified;
            final message = isNowVerified
                ? "Professional Verified Successfully"
                : "Verification Revoked Successfully";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: isNowVerified ? Colors.green : Colors.orange,
              ),
            );
            setState(() => _isLoadingAction = false);
            // Go back and refresh list
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is AdminProDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminProDetailLoaded ||
              state is AdminProDetailVerified) {
            final profile = (state is AdminProDetailLoaded)
                ? state.profile
                : (state as AdminProDetailVerified).profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profile.avatar != null
                              ? NetworkImage(profile.avatar!)
                              : null,
                          child: profile.avatar == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name ?? 'No Name',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: profile.isVerified
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            profile.isVerified
                                ? "Verified Professional"
                                : "Verification Pending",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Details
                  _DetailRow(
                      icon: Icons.work,
                      label: "Job Title",
                      value: profile.jobTitle ?? '-'),
                  _DetailRow(
                      icon: Icons.history,
                      label: "Experience",
                      value: "${profile.experience ?? 0} Years"),
                  _DetailRow(
                      icon: Icons.access_time,
                      label: "Working Hours",
                      value: profile.workingHours ?? '-'),
                  _DetailRow(
                      icon: Icons.location_on,
                      label: "Workplace",
                      value: profile.workPlace ?? '-'),

                  const SizedBox(height: 24),
                  const Text("About",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(profile.about ?? "No description provided.",
                      style:
                          TextStyle(color: Colors.grey.shade700, height: 1.5)),

                  const SizedBox(height: 24),
                  const Text("Certificates (Proof)",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (profile.certificates.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 12),
                          Text("No certificates uploaded."),
                        ],
                      ),
                    )
                  else
                    ...profile.certificates.map((cert) => CertificateCard(
                          certification: cert,
                          onEdit: () {}, // Read only
                          onRemove: () {}, // Read only
                          withActions: false,
                        )),

                  const SizedBox(height: 40),

                  // --- ACTION BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            profile.isVerified ? Colors.red : Const.aqua,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoadingAction
                          ? null
                          : () {
                              setState(() => _isLoadingAction = true);
                              if (profile.isVerified) {
                                context
                                    .read<AdminProfessionalDetailCubit>()
                                    .revokeProfessional(profile.id, role);
                              } else {
                                context
                                    .read<AdminProfessionalDetailCubit>()
                                    .verifyProfessional(profile.id, role);
                              }
                            },
                      child: _isLoadingAction
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : Text(
                              profile.isVerified
                                  ? "REVOKE VERIFICATION"
                                  : "VERIFY THIS USER",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Const.aqua.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Const.aqua, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
