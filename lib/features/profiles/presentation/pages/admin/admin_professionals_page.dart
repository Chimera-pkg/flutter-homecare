import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/presentation/bloc/admin_professionals_cubit.dart';
import 'package:m2health/features/profiles/presentation/pages/admin/admin_professional_detail_page.dart';

class AdminProfessionalsPage extends StatefulWidget {
  const AdminProfessionalsPage({super.key});

  @override
  State<AdminProfessionalsPage> createState() => _AdminProfessionalsPageState();
}

class _AdminProfessionalsPageState extends State<AdminProfessionalsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Professionals",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Const.aqua,
          indicatorColor: Const.aqua,
          tabs: const [
            Tab(text: "Nurses"),
            Tab(text: "Pharmacists"),
            Tab(text: "Radiologists"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ProfessionalListTab(role: 'nurse'),
          _ProfessionalListTab(role: 'pharmacist'),
          _ProfessionalListTab(role: 'radiologist'),
        ],
      ),
    );
  }
}

class _ProfessionalListTab extends StatefulWidget {
  final String role;
  const _ProfessionalListTab({required this.role});

  @override
  State<_ProfessionalListTab> createState() => _ProfessionalListTabState();
}

class _ProfessionalListTabState extends State<_ProfessionalListTab> {
  String _statusFilter = 'unverified'; // 'verified', 'unverified'

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProfessionalsCubit(GetIt.I<ProfileRemoteDatasource>())
        ..fetchProfessionals(widget.role, _statusFilter),
      child: BlocConsumer<AdminProfessionalsCubit, AdminProfessionalsState>(
        listener: (context, state) {
          if (state is AdminProsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.green),
            );
            // Refresh list after action
            context
                .read<AdminProfessionalsCubit>()
                .fetchProfessionals(widget.role, _statusFilter);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // --- Filter Chips ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _FilterChip(
                      label: "Waiting Verification",
                      isSelected: _statusFilter == 'unverified',
                      color: Colors.orange,
                      onTap: () {
                        setState(() => _statusFilter = 'unverified');
                        context
                            .read<AdminProfessionalsCubit>()
                            .fetchProfessionals(widget.role, 'unverified');
                      },
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: "Verified",
                      isSelected: _statusFilter == 'verified',
                      color: Colors.green,
                      onTap: () {
                        setState(() => _statusFilter = 'verified');
                        context
                            .read<AdminProfessionalsCubit>()
                            .fetchProfessionals(widget.role, 'verified');
                      },
                    ),
                  ],
                ),
              ),

              // --- List ---
              Expanded(
                child: Builder(builder: (context) {
                  if (state is AdminProsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdminProsError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  if (state is AdminProsLoaded) {
                    if (state.professionals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text("No ${_statusFilter} ${widget.role}s found.",
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.professionals.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final pro = state.professionals[index];
                        return _ProfessionalCard(
                          profile: pro,
                          role: widget.role,
                          onTap: () async {
                            final shouldRefresh =
                                await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => AdminProfessionalDetailPage(
                                  professionalId: pro.id,
                                  role: widget.role,
                                ),
                              ),
                            );

                            if (shouldRefresh == true && context.mounted) {
                              context
                                  .read<AdminProfessionalsCubit>()
                                  .fetchProfessionals(
                                      widget.role, _statusFilter);
                            }
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final ProfessionalProfile profile;
  final String role;
  final VoidCallback onTap;

  const _ProfessionalCard(
      {required this.profile, required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: profile.avatar != null
                    ? NetworkImage(profile.avatar!)
                    : null,
                child: profile.avatar == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name ?? "Unknown Name",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${profile.jobTitle ?? role.toUpperCase()} • ${profile.experience ?? 0} yrs exp",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: profile.isVerified
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  profile.isVerified ? "Verified" : "Waiting",
                  style: TextStyle(
                    color: profile.isVerified ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
